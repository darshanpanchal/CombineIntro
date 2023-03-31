//
//  ViewController.swift
//  CombineIntro
//
//  Created by Darshan on 18/01/22.
//

import UIKit
import Combine

class MyCustomTableViewCell:UITableViewCell{
    
    let button:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.systemPink
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    //pass through subject
    let action = PassthroughSubject<String,Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
    }
    @objc private func didTapButton(){
        print("Button Did Tap")
        action.send("Cool! button tapped")
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.button.frame = CGRect.init(x: 10, y: 3, width: contentView.frame.size.width - 20, height: contentView.frame.size.height-6)
        
    }
}
class ViewController: UIViewController {

    var observers:[AnyCancellable] = []
    
    private var models:[String] = []
    
    //tableview
    private let tableView:UITableView = {
        let table = UITableView()
        table.register(MyCustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(tableView)
        self.tableView.dataSource = self
        self.tableView.frame = self.view.bounds
        
        //API Call
         APICaller.shared.fetchCompanies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion{
                case .finished:
                        print("finished")
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }, receiveValue: { values in
                self.models = values
                self.tableView.reloadData()
            }).store(in: &observers)
    }


}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MyCustomTableViewCell else{
            fatalError()
        }
        
        cell.button.setTitle(self.models[indexPath.row], for: .normal)

        cell.action.sink { string in
            print("\(string)")
        }.store(in: &observers)
        
        return cell
    }
}

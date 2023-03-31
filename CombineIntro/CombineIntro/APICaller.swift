//
//  APICaller.swift
//  CombineIntro
//
//  Created by Darshan on 18/01/22.
//
import Combine
import Foundation

class APICaller{
    static let shared = APICaller()
    
    func fetchCompanies()-> Future<[String],Error>{ //publisher
        
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                promise(.success(["Apple","Google","MicroSoft","Facebook"]))
            }
            
        }
    }
}

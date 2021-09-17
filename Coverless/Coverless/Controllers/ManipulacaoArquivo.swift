//
//  ManipulacaoArquivo.swift
//  Coverless
//
//  Created by Bruno Neves Oliveira on 16/09/21.
//

import Foundation

struct Env: Codable {
    let token: String
    static let shared = PropertyListDecoder.decode("environment", to: Env.self)
}

func manipulacao(){
    
//    var mainGroup = [String]()

    var myDict: [String:String]?
    if let path = Bundle.main.path(forResource: "environment", ofType: "plist") {
        myDict = NSDictionary(contentsOfFile: path) as? [String:String]
    }
    if let dict = myDict {

        print(dict["token"]!)
        
        //print(dict)
//        for key in dict.keys.sorted() {
//
//            mainGroup.append(dict[key]!)
//        }
//
//        print(mainGroup)
    }
}

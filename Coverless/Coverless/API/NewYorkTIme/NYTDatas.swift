//
//  ApiDatas.swift
//  Coverless
//
//  Created by Gui Reis on 21/09/21.
//

import Foundation

/* MARK: - Structs para receber dados da API */

struct NYTAllBooks:Decodable {
    let num_results: Int
    let results:[NYTBook]
}

struct NYTBook:Decodable {
    let title:String?
    let description:String?
    let isbns:[NYTIsbns]
}

struct NYTIsbns:Decodable {
    let isbn10:String?
}


struct NYTCategories:Decodable {
    let results:[NYTCategory]
}

struct NYTCategory:Decodable {
    let list_name:String
    let display_name:String
    let list_name_encoded:String
    let oldest_published_date:String
    let newest_published_date:String
    let updated:String
}

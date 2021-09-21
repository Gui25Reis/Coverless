//
//  ApiDatas.swift
//  Coverless
//
//  Created by Gui Reis on 17/09/21.
//

import Foundation

/* MARK: - Structs para receber dados da API */

struct Items: Decodable {
    let items:[BookId]
}

struct BookId: Decodable {
    let id:String
    let volumeInfo:BookInformation
}

struct BookInformation: Decodable {
    let title:String?
    let description:String?
    let language:String?
}

struct Book {
    let isbn10:String
    let title:String
    let description:String
}

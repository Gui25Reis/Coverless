//
//  ApiDatas.swift
//  Coverless
//
//  Created by Gui Reis on 17/09/21.
//

import Foundation

/* MARK: - Dados da API */

struct Items: Decodable {
    let totalItems:Int
    let items:[BookId]
}

struct BookId: Decodable {
    let id:String?
    let volumeInfo:BookInformation
    let saleInfo:BookShop?
}

struct BookInformation: Decodable {
    let title:String?
    let description:String?
    let imageLinks:BookImages?
    let authors:[String]?
    let publisher:String?
}


struct BookImages:Decodable {
    let smallThumbnail:String?
    let thumbnail:String?
}


struct BookShop:Decodable {
    let buyLink:String?
}


/* MARK: - Outros */

/**
    Salva as informaçòes da última cateogira usada na APi do Google Books
*/
struct UsedCategory {
    var maxBooks:Int
    var avaiable:[Int]
    var cont:Int
}


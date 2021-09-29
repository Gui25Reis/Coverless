//
//  ApiDatas.swift
//  Coverless
//
//  Created by Gui Reis on 21/09/21.
//

import Foundation

/* MARK: - Livros */

struct NYTAllBooks:Decodable {
    let num_results:Int
    let results:NYTBookInfo
}

struct NYTBookInfo:Decodable {
    let books:[NYTBook]
}

struct NYTBook:Decodable {
    let title:String?
    let description:String?
    let author:String?
    let publisher:String?
    let primary_isbn10:String?
    let primary_isbn13:String?
    let book_image:String?
    let buy_links:[NYTBookShop]?
    
}

struct NYTBookShop:Decodable {
    let name:String
    let url:String
}


/* MARK: - Categorias */

struct NYTCategories:Decodable {
    let results:[NYTCategory]
}

struct NYTCategory:Decodable {
    let list_name:String
    // let display_name:String
    let list_name_encoded:String
    let oldest_published_date:String
    let newest_published_date:String
    let updated:String
}

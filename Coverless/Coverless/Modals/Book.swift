//
//  Book.swift
//  Coverless
//
//  Created by Gui Reis on 24/09/21.
//


/**
    Todas as informações necessárias do livro.
 
    Obs:
        - id == nil: New York Times
        - isbn10 == nil: Google Books
*/
struct Book {
    let id:String?
    let isbn10:String?
    let title:String
    let description:String
    let image:String?
    let author:String
    let publisher:String
    let buyLinks:[String:String]?
}

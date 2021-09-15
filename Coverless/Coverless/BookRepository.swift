//
//  BookRepository.swift
//  Coverless
//
//  Created by Gui Reis on 14/09/21.
//

import UIKit
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
    var title:String?
    var description:String?
    var language:String?
}


struct Book {
    let id:String
    let title:String
    let description:String
}



class BookRepository {
    private let token = "AIzaSyCN2r5ED0n-OeohIezXvWCGzskdhZ61x-E"
    private var books:[Book] = []
    
    public func getRandomizedBooks(_ completionHandler: @escaping (Result<[Book], Error>) -> Void) {
        
        self.books = []
        
        let session = URLSession.shared
        
        let randomNumber:Int = Int.random(in: 0...200)
        
        let apiUrl = "https://www.googleapis.com/books/v1/volumes?q=amor+subject:&startIndex=\(randomNumber)&maxResults=40&printType=books"
        
        session.dataTask(with: URL(string: apiUrl+"&key=\(self.token)")!) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let data = data {
                    let decoder = JSONDecoder()
                    let books = try! decoder.decode(Items.self, from: data)
                    
                    self.compactInfo(items: books)
                    
                    completionHandler(.success(self.books))
                }
            }
        }.resume()
    }
    

    private func compactInfo (items:Items) -> Void {
        // Uso com Filter
//        return items.items.filter { item in
//            item.volumeInfo.title != nil &&
//            item.volumeInfo.description != nil &&
//            item.volumeInfo.language != nil &&
//            item.volumeInfo.language == "pt"
//        }.map {
//            Book(id: $0.id, title: $0.volumeInfo.title! , description: $0.volumeInfo.description!)
//        }
        
        // Uso com for
        for b in items.items {
            if b.volumeInfo.title != nil, b.volumeInfo.description != nil, b.volumeInfo.language != nil, b.volumeInfo.language == "pt" {
                self.books.append (
                    Book(
                        id: b.id,
                        title: b.volumeInfo.title!,
                        description: b.volumeInfo.description!
                    )
                )
            }
        }
    }
}

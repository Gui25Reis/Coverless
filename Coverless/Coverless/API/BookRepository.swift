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
    private var books:[Book] = []
    
    public func getRandomizedBooks(text:String, _ completionHandler: @escaping (Result<[Book], Error>) -> Void) {
        self.books = []
        
        let session = URLSession.shared
        
        let randomNumber:Int = Int.random(in: 0...200)
        
        let apiUrl = "https://www.googleapis.com/books/v1/volumes?q=\(text)+subject:&startIndex=\(randomNumber)&maxResults=40&printType=books"
        
        session.dataTask(with: URL(string: apiUrl+"&key=\(self.getToken())")!) { data, response, error in
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
    
    
    private func getToken() -> String {
        var myDict: [String:String]?
        if let path = Bundle.main.path(forResource: "Environment", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path) as? [String:String]
        }
        return myDict!["token"]!
    }

    
    private func compactInfo (items:Items) -> Void {
        for b in items.items {
            if b.volumeInfo.title != nil, b.volumeInfo.description != nil { //, b.volumeInfo.language != nil, b.volumeInfo.language == "pt" {
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


/* Como usar a função:
 
@objc func buttonAction() -> Void {
    
    api.getRandomizedBooks(text: "adventure") { result in
        
        switch result {
            case .success(let book):
                self.success(book)
                break
                
            case .failure(let error):
                print("Erro API: \(error)")
                break
        }
    }
}
 
private func success(_ books:[Book]) -> Void {
    for b in books {
        print("Id: \(b.id)")
        print("Title: \(b.title)")
        print("Sinopse: \(b.description)\n\n")
    }
    print("===== Total de livros: \(books.count) =====\n")
}
*/

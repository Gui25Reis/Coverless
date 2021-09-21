//
//  NYTRepository.swift
//  Coverless
//
//  Created by Gui Reis on 21/09/21.
//

import Foundation

/**
    Classe responsável pela comunicação direta com a API do Google Books
*/
class NYTRepository {
    private var books:[Book] = []
    private var categories:[NYTCategory] = []
    
    
    /**
        Faz a chamada da API com base na palavra chave.
     
        - Parametros:
            - text: palavra chave para fazer a busca na API
 
        - CompletionHandler:
            - Result: lista dos livors recebidos (lista com no máximo 40 livros)
            - Error: erro caso tenha algum
    */
    public func getBooks(text:String, _ completionHandler: @escaping (Result<[Book], Error>) -> Void) -> Void {
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
                    let books = try! decoder.decode(NYTAllBooks.self, from: data)
                    
                    self.compactBookInfo(items: books)
                    
                    completionHandler(.success(self.books))
                }
            }
        }.resume()
    }
    
    
    /**
        Pega a chave para acessa a API
     
        - Return: chave da API
    */
    private func getToken() -> String {
        var myDict: [String:String]?
        if let path = Bundle.main.path(forResource: "Environment", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path) as? [String:String]
        }
        return myDict!["NewYorkKey"]!
    }

    
    /**
        Faz a filtragem dos dados recebido e retorna os parâmetros necessários e escolhidos
    */
    private func compactBookInfo(items:NYTAllBooks) -> Void {
        for c in items.results {
            if c.title != nil, c.description != nil, c.isbns[0].isbn10 != nil {
                self.books.append(
                    Book(
                        isbn10: c.isbns[0].isbn10!,
                        title: c.title!,
                        description: c.description!)
                )
            }
        }
    }
    
    
    
    /**
        Faz a filtragem dos dados recebido e retorna os parâmetros necessários e escolhidos
    */
    private func compactCategoryInfo(items:NYTCategories) -> Void {
        for c in items.results {
            self.categories.append (
                NYTCategory(
                    list_name: c.list_name,
                    display_name: c.display_name,
                    list_name_encoded: c.list_name_encoded,
                    oldest_published_date: c.oldest_published_date,
                    newest_published_date: c.newest_published_date,
                    updated: c.updated
                )
            )
        }
    }
    
    
    /**
         Pega todas as categorias disponiveis pela API
      
         - Return: uma lista com todoas as categorias que a API disponibiliza
    */
    public func getCategories(_ completionHandler: @escaping (Result<[NYTCategory], Error>) -> Void) -> Void {
        let session = URLSession.shared
        
        let apiUrl = "https://api.nytimes.com/svc/books/v3/lists/names.json?"
                
        session.dataTask(with: URL(string: apiUrl+"&api-key=\(self.getToken())")!) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let data = data {
                    let decoder = JSONDecoder()
                    let categories = try! decoder.decode(NYTCategories.self, from: data)
                    
                    self.compactCategoryInfo(items: categories)
                    
                    completionHandler(.success(self.categories))
                }
            }
        }.resume()
    }
}

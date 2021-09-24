//
//  BookRepository.swift
//  Coverless
//
//  Created by Gui Reis on 14/09/21.
//

import Foundation


/**
    Classe responsável pela comunicação direta com a API do Google Books
*/
class GoogleRepository {
    private var books:[Book] = []
    private lazy var lastCategory:[String:UsedCategory] = [:]
    
    
    /**
        Faz a chamada da API com base na palavra chave.
     
        - Parametros:
            - text: palavra chave para fazer a busca na API
 
        - CompletionHandler:
            - Result: lista dos livors recebidos (lista com no máximo 40 livros)
            - Error: erro caso tenha algum
    */
    public func getBooks(text:String, _ completionHandler: @escaping (Result<[Book], Error>) -> Void) -> Void {
        
        // Verifica se essa categoria ja foi usada
        var used:Bool = false
        if (self.lastCategory[text] != nil) {used = true}
        else {self.lastCategory = [:]}
        
        // Se essa categoria já foi escolhida pega novos livros
        var startIndex:Int = 0
        if (used) {
            startIndex = self.lastCategory[text]!.timesUsed * 40
            if (startIndex > self.lastCategory[text]!.maxBooks) {return}
        }
        
        
        

        self.books = []

        // API:
        let session = URLSession.shared
        
        var apiUrl = "https://www.googleapis.com/books/v1/volumes?"             // Chamada normal
        apiUrl += "q=\(text)+subject:"                                          // Palavra chave + filtro
        apiUrl += "&startIndex=\(startIndex)&maxResults=40&printType=books"     // Parte da lista
        
        session.dataTask(with: URL(string: apiUrl+"&key=\(self.getToken())")!) { data, response, error in
            // if let error = error {
            if (error != nil) {// || (self.lastCategory[text] != nil && startIndex > self.lastCategory[text]!.maxBooks) {
                completionHandler(.failure(error!))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let data = data {
                    let decoder = JSONDecoder()
                    let books = try! decoder.decode(Items.self, from: data)
                    
                    self.compactInfo(items: books)
                    
                    if (used) {self.lastCategory[text]?.timesUsed = self.lastCategory[text]!.timesUsed + 1}
                    else {self.lastCategory[text] = UsedCategory(maxBooks: books.totalItems, timesUsed: 1)}
                    
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
        return myDict!["GoogleKey"]!
    }

    
    /**
        Faz a filtragem dos dados recebido para os livros
     
        - Parâmetros:
            - items: Struct com as informações recebidas da API
    */
    private func compactInfo(items:Items) -> Void {
        for b in items.items {
            //print(b.volumeInfo)
            //print("\n\n")
            if ( // Condições para pegar um livro
                b.volumeInfo.title != nil &&
                b.volumeInfo.description != nil &&
                b.saleInfo != nil &&
                b.saleInfo!.buyLink != nil &&
                b.volumeInfo.imageLinks != nil &&
                b.volumeInfo.imageLinks!.thumbnail != nil &&
                b.volumeInfo.imageLinks!.smallThumbnail != nil
            ){
                self.books.append(
                    Book(
                        id: b.id,
                        isbn10: nil,
                        title: b.volumeInfo.title!.capitalized,
                        description: b.volumeInfo.description!,
                        image:b.volumeInfo.imageLinks!.thumbnail!,
                        buyLinks:["Google Books":"\(b.saleInfo!.buyLink!)"]
                    )
                )
            }
        }
    }
}

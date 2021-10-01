//
//  BookRepository.swift
//  Coverless
//
//  Created by Gui Reis on 14/09/21.
//

import Foundation


/**
    Classe responsável pela comunicação direta com a API do Google Books
 
    Aqui é feita as requisições para API do Google books. Sempre que é feito uma nova chamada de uma categoria
 vai ser retornado uma nova lista de livros. Só vai repetir a lista de livros quando acabar os diferentes, ai a lista passa
 a repetir.
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
        
        // Se essa categoria já foi escolhida pega novos livros
        var startIndex:Int = 0
        if (used) {startIndex = (self.lastCategory[text]?.avaiable[0])!}
                
        self.books = []

        // API:
        let session = URLSession.shared
        
        var apiUrl = "https://www.googleapis.com/books/v1/volumes?"             // Chamada normal
        apiUrl += "q=\(NYTRepository.fixStringSpaces(text))+subject:"           // Palavra chave + filtro
        apiUrl += "&startIndex=\(startIndex)&maxResults=40"                     // Momento da lista
        apiUrl += "&printType=books&langRestrict=en"                            // Tipo de resultado
        
        
        session.dataTask(with: URL(string: apiUrl+"&key=\(self.getToken())")!) { data, response, error in
            if (error != nil) {
                completionHandler(.failure(error!))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let data = data {
                    let decoder = JSONDecoder()
                    let books = try! decoder.decode(Items.self, from: data)
                    
                    self.compactInfo(items: books)
                    
                    if (used) {
                        self.lastCategory[text]?.avaiable.removeFirst()
                        print("\nCategoria: \(text) - Faltam: \(self.lastCategory[text]!.avaiable.count)\n")
                        self.lastCategory[text]?.cont += self.books.count
                    }
                    if (!used || self.lastCategory[text]?.avaiable.count == 0) {
                        print("\n\n\nAcabou \(text): \(self.lastCategory[text]?.cont ?? 0) de \(self.lastCategory[text]?.maxBooks ?? 0)\n\n\n")
                        
                        self.lastCategory[text] = UsedCategory(
                            maxBooks: books.totalItems,
                            avaiable: Array(1...books.totalItems/40).shuffled(),
                            cont: 0
                        )
                    }
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
                b.volumeInfo.imageLinks!.smallThumbnail != nil &&
                b.volumeInfo.publisher != nil &&
                b.volumeInfo.authors != nil &&
                b.volumeInfo.authors != []
            ){
                var allAuthors:String = ""
                for author in b.volumeInfo.authors! {allAuthors += author + " ,"}
                
                self.books.append(
                    Book(
                        id: b.id,
                        isbn10: nil,
                        title: b.volumeInfo.title!.capitalized,
                        description: b.volumeInfo.description!,
                        image:b.volumeInfo.imageLinks!.thumbnail!,
                        author: String(allAuthors.dropLast()),
                        publisher: b.volumeInfo.publisher!,
                        buyLinks:["Google Books":"\(b.saleInfo!.buyLink!)"]
                    )
                )
            }
        }
    }
}

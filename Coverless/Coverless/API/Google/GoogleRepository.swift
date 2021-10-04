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
    private lazy var lastCategory:[String:Int] = [:]
    private lazy var lastCategoryCont:[String:Int] = [:]
    private lazy var textUsed:String = ""
    
    /**
        Faz a chamada da API com base na palavra chave.
     
        - Parametros:
            - text: palavra chave para fazer a busca na API
 
        - CompletionHandler:
            - Result: lista dos livors recebidos (lista com no máximo 40 livros)
            - Error: erro caso tenha algum
    */
    public func getBooks(text:String, _ completionHandler: @escaping (Result<[Book], Error>) -> Void) -> Void {
        var startIndex:Int = 0
        var used:Bool = false
        
        if let _ = self.lastCategory[text] {
            used = true
            self.lastCategory[text]? += 1
            startIndex = self.lastCategory[text]!
        }
        
        guard let url = URL(string: self.getUrl(text, startIndex)) else {
            completionHandler(.failure(APIError.badURL))
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Erro da sessão
            if let error = error {
                completionHandler(.failure(APIError.url(error as? URLError)))
                return
            }
            
            // Não fez conexão com a API: servidor ou internet off
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completionHandler(.failure(APIError.badResponse(statusCode: response.statusCode)))
                return
            }
            
            // Erro na hora de pagar os dados
            guard let data = data else {
                completionHandler(.failure(APIError.badData))
                return
            }
            
            // Erro na hora de decodificar
            guard let books = try? JSONDecoder().decode(Items.self, from: data) else {
                completionHandler(.failure(APIError.badDecode))
                return
            }
            
            // Acessando um index que não existe
            guard let _ = books.items else {
                // print("\n\n\n\t====== Categoria: \(text) - \(self.lastCategoryCont[text] ?? 0) livors.======\n\n\n")
                self.lastCategory[text]? = -1
                self.getBooks(text: text) { result in
                    switch result {
                    case .success(let book):
                        completionHandler(.success(book))
                        
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
                return
            }
                        
            if (!used) {self.lastCategory[text] = 0; self.lastCategoryCont[text] = 0}
            
            // print("Deu certo")
            self.textUsed = text
            completionHandler(.success(self.compactInfo(items: books)))
        }
        task.resume()
    }
    
    
    /**
        Pega a chave para acessa a API
     
        - Return: chave da API
    */
    private func getToken() -> String {
        // Verifica se o arquivo existir
        guard let path = Bundle.main.path(forResource: "Environment", ofType: "plist") else {return ""}
        
        let myDict = NSDictionary(contentsOfFile: path) as? [String:String]
        
        // Verifica se tem a chave
        guard let key = myDict?["GoogleKey"] else {return ""}
        
        return key
    }

    
    
    /**
        Cria a URL para fazer a chamada na API
     
        - Return: url da requisição
    */
    private func getUrl(_ text:String, _ startIndex:Int) -> String {
        let key = self.getToken()
        if key == "" {return ""}
        
        var apiUrl = "https://www.googleapis.com/books/v1/volumes?"             // Chamada normal
        apiUrl += "q=subject:\(NYTRepository.fixStringSpaces(text))"            // Palavra chave + filtro
        apiUrl += "&startIndex=\(startIndex * 40)&maxResults=40"                // Momento da lista
        apiUrl += "&printType=books&langRestrict=en"                            // Tipo de resultado
        apiUrl += "&key=\(key)"                                                 // Token
        return apiUrl
    }
    
    /**
        Faz a filtragem dos dados recebido para os livros
     
        - Parâmetros:
            - items: Struct com as informações recebidas da API
    */
    private func compactInfo(items:Items) -> [Book] {
        var books:[Book] = []
        
        if let items = items.items {
            for info in items {
                // Condições para pegar um livro
                if let id = info.id,
                   let title = info.volumeInfo.title,
                   let authors = info.volumeInfo.authors,
                   let publisher = info.volumeInfo.publisher,
                   let description = info.volumeInfo.description //,
                   // let _ = info.saleInfo,
                   // let buyLink = info.saleInfo!.buyLink,
                   // let _ = info.volumeInfo.imageLinks,
                   // let imgThumbnail = info.volumeInfo.imageLinks!.thumbnail
                {
                    var allAuthors:String = ""
                    for author in authors {allAuthors += author + " ,"}
                    
                    books.append(
                        Book(
                            id: id,
                            isbn10: nil,
                            title: title.capitalized,
                            description: description,
                            image: "",//imgThumbnail,
                            author: String(allAuthors.dropLast()),
                            publisher: publisher,
                            buyLinks: [:]//["Google Books":"\(buyLink)"]
                        )
                    )
                }
            }
        }
        self.lastCategoryCont[self.textUsed]! += books.count
        return books
    }
}

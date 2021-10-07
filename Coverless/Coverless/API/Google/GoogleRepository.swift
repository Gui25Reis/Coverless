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
    private var currentBooks: [String : [Book]] = [:]
    
    func getBooks(text: String, _ completionHandler: @escaping (Result<[Book], Error>) -> Void) {
        
        guard currentBooks[text] == nil else {
            completionHandler(.success(getRandomBooks(of: currentBooks[text]!)))
            return
        }
        
        guard let url = URL(string: getUrl(text, 0)) else {
            completionHandler(.failure(APIError.badURL))
            return
        }
        
        var books: [Book] = []
        
        let dispatchGroup = DispatchGroup()
        let elementCount = 40
        
        dispatchGroup.enter()
        fetchBook(for: url) {[weak self] result in
            defer { dispatchGroup.leave() }
            guard let self = self else {
                completionHandler(.failure(APIError.badResponse(statusCode: 500)))
                return
            }
            
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let items):
                let totalPages = (items.totalItems/elementCount)
                books.append(contentsOf: self.compactInfo(items: items))
                
                Array(1..<totalPages).forEach { index in
                    
                    guard let url = URL(string: self.getUrl(text, 0)) else {
                        completionHandler(.failure(APIError.badData))
                        return
                    }
                    
                    dispatchGroup.enter()
                    self.fetchBook(for: url) { result in
                        defer { dispatchGroup.leave() }
                        switch result {
                        case .failure(let error):
                            completionHandler(.failure(error))
                        case .success(let items):
                            books.append(contentsOf: self.compactInfo(items: items))
                        }
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {[weak self] in
            guard let self = self else { return }
            self.currentBooks[text] = books
            completionHandler(.success(self.getRandomBooks(of: books)))
        }
        
        
    }
    
    private func getRandomBooks(of books: [Book]) -> [Book] {
        
        guard books.count > 10 else {
            return books
        }
        
        var shuffledBooks = books
        shuffledBooks.shuffle()
        
        return shuffledBooks
            .enumerated()
            .filter { (index, element) in
            index < 10 }
            .map { $1 }
    }
    
    private func fetchBook(for url: URL, _ completionHandler: @escaping (Result<Items, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completionHandler(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard
                    let data = data,
                    let items = try? JSONDecoder().decode(Items.self, from: data)
                else {
                    completionHandler(.failure(APIError.badData))
                    return
                }
                
                completionHandler(.success(items))

            } else {
                completionHandler(.failure(APIError.badResponse(statusCode: 404)))
            }
        }.resume()
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
                   let description = info.volumeInfo.description
                {
                    var allAuthors:String = ""
                    for author in authors {allAuthors += author + " ,"}
                    
                    books.append(
                        Book(
                            id: id,
                            isbn10: nil,
                            title: title.capitalized,
                            description: description,
                            image: info.volumeInfo.imageLinks?.thumbnail,
                            author: String(allAuthors.dropLast()),
                            publisher: publisher,
                            buyLinks: ["Google Books":"\(info.saleInfo?.buyLink ?? "")"]
                        )
                    )
                }
            }
        }
        return books
    }
}

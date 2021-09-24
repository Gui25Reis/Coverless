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
    private var categories:[String:NYTCategory] = [:]
    
    
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
        
        let session:URLSession = URLSession.shared
                
        var apiUrl:String = "https://api.nytimes.com/svc/books/v3/lists/"       // Chamada padrão
        apiUrl += "\(self.getDate(category: self.categories[text]!))"           // Data randomica
        apiUrl += "/\(self.fixStringSpaces(text)).json?"                        // Filtragem pela categoria
        
        session.dataTask(with: URL(string: apiUrl+"api-key=\(self.getToken())")!) { data, response, error in
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
         Pega todas as categorias disponiveis pela API
      
         - Return: um dicionário com as chaves sendo as categorias e pos valores as informações delas.`
    */
    public func getCategories(_ completionHandler: @escaping (Result<[String:NYTCategory], Error>) -> Void) -> Void {
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
                    
                    completionHandler(.success(self.compactCategoryInfo(items: categories)))
                }
            }
        }.resume()
    }
    
    
    /**
        Escolhe uma data aleatória a partir da data mais antiga
     
        - Parametros:
            - category: categoria onde a data vai ser escolhida
 
        - Return: data escolhida entre o perido de livros públicados a partir da cateogira escolhida
    */
    private func getDate(category:NYTCategory) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let start:Date = dateFormatter.date(from: category.oldest_published_date)!
        let end:Date = dateFormatter.date(from: category.newest_published_date)!
        
        var randomNumber:Int?
        var finalDate:String?
        
        switch category.updated {
            
            case "MONTHLY":
                let diference = calendar.dateComponents([.month], from: start, to: end).month!
                randomNumber = Int.random(in: 0...diference)
                
                let randomDate = calendar.date(byAdding: .month, value: randomNumber!, to: start)
                finalDate = dateFormatter.string(from: randomDate!)
                
            case "WEEKLY":
                let diference = calendar.dateComponents([.weekOfMonth], from: start, to: end).weekOfMonth!
                randomNumber = Int.random(in: 0...diference)
                
                let randomDate = calendar.date(byAdding: .weekOfYear, value: randomNumber!, to: start)
                finalDate = dateFormatter.string(from: randomDate!)
                            
            default:
                print("Novo tipo de atualização!")
        }
        
        if (randomNumber != nil && finalDate != nil) {
            return finalDate!
        }
        
        print("Deu algum erro na hora de pegar uma data.")
        return ""
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
        Converte os espaços da String para %20 para fazer a chamda na API
     
        - Parametros:
            - str: String que vai ser manipulada
 
        - Return: nova string
    */
    private func fixStringSpaces(_ str:String) -> String {
        return str.replacingOccurrences(of: " ", with: "%20")
    }
    
    
    /**
        Faz a filtragem dos dados recebido para os livros
     
        - Parâmetros:
            - items: Struct com as informações recebidas da API
    */
    private func compactBookInfo(items:NYTAllBooks) -> Void {
        for c in items.results.books {
            if ( // Condições para pegar um livro
                c.title != nil &&
                c.title != "None" &&
                c.description != nil &&
                c.description?.isEmpty == false &&
                c.primary_isbn10 != nil &&
                c.primary_isbn10 != "None" &&
                c.book_image != nil &&
                c.buy_links != nil
            ){
                var salesDict:[String:String] = [:]
                for sales in c.buy_links! {salesDict[sales.name] = sales.url}
                
                self.books.append(
                    Book(
                        id: nil,
                        isbn10: c.primary_isbn10!,
                        title: c.title!.capitalized,
                        description: c.description!,
                        image: c.book_image!,
                        buyLinks: salesDict
                    )
                )
            }
        }
    }
    
    
    /**
        Faz a filtragem dos dados recebido para as categorias
     
        - Parâmetros:
            - items: Struct com as informações recebidas da API
    */
    private func compactCategoryInfo(items:NYTCategories) -> [String:NYTCategory] {
        var dict:[String:NYTCategory] = [:]
        for c in items.results {
            dict[c.list_name] = NYTCategory(
                list_name: c.list_name,
                // display_name: c.display_name,
                // list_name_encoded: c.list_name_encoded,
                oldest_published_date: c.oldest_published_date,
                newest_published_date: c.newest_published_date,
                updated: c.updated
            )
        }
        self.categories = dict
        return dict
    }
}

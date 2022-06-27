//
//  CoverlessDataRepositorio.swift
//  Coverless
//
//  Created by Beatriz Duque on 23/09/21.
//
import Foundation
import CoreData

class DataBooks{
    static let shared:DataBooks = DataBooks()
    
    private let imageFetcher: ImageFetcher
    private init(imageFetcher: ImageFetcher = ImageFetcher.shared) {
        self.imageFetcher = imageFetcher
    }
    
    var contenxt: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    ///var privada ja que nao vai ser acessada
    private lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "CoverlessData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Buscar todas as reuniões no banco de dados
    func getBooks() -> [MyBook] {
        let fr = NSFetchRequest<MyBook>(entityName: "MyBook")
        do {
            return try self.persistentContainer.viewContext.fetch(fr)
        }catch {
            print(error)
        }
        
        return []
    }
    
    func addBook(book: Book) {
        let livro = MyBook(context: self.persistentContainer.viewContext)
        
        livro.id = book.id
        livro.status = Int32(2)
        livro.title = book.title
        livro.rating = 5
        livro.isFavorite = false
        livro.synopsis = book.description
        
        if let links = book.buyLinks{
            livro.shopLink =  Array(links.values)[0]
        }
        //livro.shopLink = Array(book.buyLinks.values)[0]
        
        imageFetcher.saveImage(from: URL(string: book.image ?? "")) {[weak self] res in
            
            guard let self = self else { return }
            
            switch res {
            case .failure(_):
                livro.imagePath = nil
            case .success(let path):
                livro.imagePath = path
            }

            self.saveContext()
        }
    }
    
    func deleta(item: MyBook) throws{
        self.persistentContainer.viewContext.delete(item)
        self.saveContext()
    }

}

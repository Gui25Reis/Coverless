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
    private init() {}
    
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
    
    func addBook(id: String,title:String, status: Int32,rating: Int32,isFavorite: Bool) -> MyBook {
        let livro = MyBook(context: self.persistentContainer.viewContext)
        
        livro.id = id
        livro.status = status
        livro.title = title
        livro.rating = rating
        livro.isFavorite = isFavorite
        
        self.saveContext()
        return livro
    }
    
    func deleta(item: MyBook) throws{
        self.persistentContainer.viewContext.delete(item)
        self.saveContext()
    }

}

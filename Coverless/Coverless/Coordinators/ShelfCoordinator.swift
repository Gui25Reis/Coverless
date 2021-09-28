//
//  ShelfCoordinator.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 16/09/21.
//

import UIKit
class ShelfCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.setupBarAppearence()
    }
    
    func start() {
        let vc = ShelfViewController()
        vc.coordinator = self
        vc.navigationItem.title = "Shelf"
        let tabBarItem2 = UITabBarItem(title: "Shelf", image: UIImage(systemName: "books.vertical"), tag: 1)
        tabBarItem2.selectedImage = UIImage(systemName: "books.vertical.fill")
        vc.tabBarItem = tabBarItem2
        navigationController.pushViewController(vc, animated: true)
    }
    
    //atualizar funcao para func showBook(book: MyBook)
    func showBook() {
        let vc = BookViewController()

        vc.coordinator = self
        vc.navigationItem.title = "Book Title"
        navigationController.pushViewController(vc, animated: true)
    }
    private func setupBarAppearence() {
        let designSystem: DesignSystem = DefaultDesignSystem.shared
        
        navigationController.navigationBar.prefersLargeTitles = true
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: designSystem.palette.titlePrimary]
        UINavigationBar.appearance().barTintColor = designSystem.palette.backgroundPrimary
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: designSystem.palette.titlePrimary]
    }
    
}

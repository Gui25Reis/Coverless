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
        vc.tabBarItem = UITabBarItem(title: "Shelf", image: UIImage(systemName: "books.vertical"), tag: 1)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showBook(viewModel: MoreInfoViewModel) {
        let vc = BookViewController(viewModel: viewModel)
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

//
//  MainCoordinator.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 16/09/21.
//

import UIKit

class DiscoverCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.setupBarAppearence()
    }
    
    func start() {
        let vc = DiscoverViewController()
        vc.coordinator = self
        let tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "lightbulb"), tag: 0)
        tabBarItem.selectedImage = UIImage(systemName: "lightbulb.fill")
        vc.tabBarItem = tabBarItem
        vc.navigationItem.title = "Discover"
        navigationController.pushViewController(vc, animated: true)
        
    }
    
    func showMoreInfo(viewModel: MoreInfoViewModel) {
        let vc = MoreInfoViewController(viewModel: viewModel)
        vc.coordinator = self
        vc.navigationItem.title = "More info"
        navigationController.pushViewController(vc, animated: true)
    }
    
    func discoverBook(book: Book) {
        let vc = DiscoveredBookViewController(book: book)
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    private func setupBarAppearence() {
        let designSystem: DesignSystem = DefaultDesignSystem.shared
        
        navigationController.navigationBar.prefersLargeTitles = true
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: designSystem.palette.titlePrimary]
        UINavigationBar.appearance().barTintColor = designSystem.palette.backgroundPrimary
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: designSystem.palette.titlePrimary]
    }
    
}

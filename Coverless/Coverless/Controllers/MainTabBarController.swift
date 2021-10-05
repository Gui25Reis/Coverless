//
//  MainTabBarController.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 16/09/21.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let designSystem: DesignSystem = DefaultDesignSystem.shared
    private let discover = DiscoverCoordinator(navigationController: UINavigationController())
    private let shelf = ShelfCoordinator(navigationController: UINavigationController())
    
    override func viewDidLoad() {
        discover.start()
        shelf.start()
        viewControllers = [discover.navigationController, shelf.navigationController]
        tabBar.barTintColor = designSystem.palette.backgroundPrimary
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            appearance.backgroundColor = designSystem.palette.backgroundPrimary
        }
    }
}

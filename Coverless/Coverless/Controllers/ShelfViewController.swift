//
//  ShelfViewController.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 16/09/21.
//

import UIKit

final class ShelfViewController: UIViewController {
    
    weak var coordinator: ShelfCoordinator?
    
    override func viewDidLoad() {
        view.backgroundColor = .backgroundPrimary
    }
}

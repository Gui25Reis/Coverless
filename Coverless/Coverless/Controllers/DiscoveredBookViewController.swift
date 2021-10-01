//
//  DiscoverBookViewController.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 30/09/21.
//

import UIKit

class DiscoveredBookViewController: UIViewController {
    
    private let contentView: DiscoveredBookView
    private let book: Book
    
    init(book:Book, designSystem: DesignSystem = DefaultDesignSystem()) {
        self.book = book
        self.contentView = DiscoveredBookView(designSystem: designSystem, book: book)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

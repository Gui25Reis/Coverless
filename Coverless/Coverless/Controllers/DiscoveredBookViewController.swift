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
    private lazy var barButtonItem: UIBarButtonItem  = .init(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
    
    weak var coordinator: DiscoverCoordinator?
    
    init(book:Book, designSystem: DesignSystem = DefaultDesignSystem()) {
        self.book = book
        self.contentView = DiscoveredBookView(designSystem: designSystem, book: book)
        let _ = DataBooks.shared.addBook(book: book)
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
        contentView.accessibilityViewIsModal = true
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc
    private func didTapDone() {
        UIAccessibility.post(notification: .screenChanged, argument: coordinator?.navigationController)
        dismiss(animated: true, completion: nil)
    }

}

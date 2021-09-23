//
//  MoreInfoViewController.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 17/09/21.
//

import UIKit

final class MoreInfoViewController: UIViewController {
    weak var coordinator: DiscoverCoordinator?
    
    lazy var contentView: MoreInfoView = {
        MoreInfoView(designSystem: DefaultDesignSystem.shared, tabBarHeight: tabBarController?.tabBar.frame.height ?? 100)
    }()
    
    let viewModel: MoreInfoViewModel
    
    init(viewModel: MoreInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        contentView.setupContent(synopsis: viewModel.synopsis, rating: viewModel.rating)
        contentView.setupButtonBinding(addToShelf)
    }
    
    private func addToShelf() {
        print("Adding book to shelf")
    }
}

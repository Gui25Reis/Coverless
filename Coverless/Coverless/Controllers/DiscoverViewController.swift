//
//  ViewController.swift
//  Coverless
//
//  Created by Gui Reis on 14/09/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    weak var coordinator: DiscoverCoordinator?
    
    private let contentView: DiscoverView
    private let dataSource: DiscoverCollectionViewDataSource
    
    private var state: ViewState { didSet {
        handleState()
    }}
    
    enum ViewState {
        case presenting, loading, error, refreshing
    }
    
    init(designSystem: DesignSystem = DefaultDesignSystem(),
         dataSource: DiscoverCollectionViewDataSource = DiscoverCollectionViewDataSource()) {
        self.contentView = DiscoverView()
        self.dataSource = dataSource
        self.state = .loading
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSubjectNotification(_:)), name: .didSelectSubject, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func loadView() {
        view = contentView
        
    }
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
        dataSource.cellDelegate = self
        dataSource.footerDelegate = self
        
        contentView.bindCollectionView(delegate: self, dataSource: dataSource)
        handleLoadingState()
        selectBooks()
        
        if let refreshControl = contentView.collectionView.refreshControl {
            refreshControl.addTarget(self, action: #selector(refreshBooks), for: .valueChanged)
        }
    }
    
    @objc
    private func handleSubjectNotification(_ notification: Notification) {
        selectBooks()
    }
    
    private func selectBooks() {
        self.state = .loading
        dataSource.fetchBooks { [weak self] in
            DispatchQueue.main.async {
                self?.state = .presenting
                self?.contentView.collectionView.reloadData()
            }
        }
    }
    
    @objc
    private func refreshBooks() {
        self.state = .refreshing
        dataSource.fetchBooks { [weak self] in
            DispatchQueue.main.async {
                self?.state = .presenting
                self?.contentView.collectionView.reloadData()
            }
        }
    }
    
    private func handleState() {
        switch state {
        case .presenting:
            handlePresetingState()
        case .loading:
            handleLoadingState()
        case .error:
            handleErrorState()
        case .refreshing:
            handleRefreshState()
        }
    }
    
    private func handlePresetingState() {
        contentView.setupPresentationState()
    }
    
    private func handleLoadingState() {
        contentView.setupLoadingState()
    }
    
    private func handleErrorState() {
        
    }
    
    private func handleRefreshState() {
        contentView.setupRefreshState()
    }

}
extension DiscoverViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }
    
}

extension DiscoverViewController: SynopsisCellDelegate {
    func showInfo(for book: Book) {
        coordinator?.showMoreInfo(for: book)
    }
    
    func discoverBook(_ book: Book) {
        coordinator?.discoverBook(book: book)
    }
    
}

extension DiscoverViewController: DiscoverViewFooterDelegate {
    func refreshList() {
        refreshBooks()
    }
}

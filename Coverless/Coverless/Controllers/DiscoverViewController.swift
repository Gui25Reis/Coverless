//
//  ViewController.swift
//  Coverless
//
//  Created by Gui Reis on 14/09/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    weak var coordinator: DiscoverCoordinator?
    
    let contentView: DiscoverView
    let dataSource: DiscoverCollectionViewDataSource
    
    init(designSystem: DesignSystem = DefaultDesignSystem(),
         dataSource: DiscoverCollectionViewDataSource = DiscoverCollectionViewDataSource()) {
        self.contentView = DiscoverView()
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
        
    }
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
        dataSource.cellDelegate = self
        contentView.bindCollectionView(delegate: self, dataSource: dataSource)
    }

}
extension DiscoverViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            updateSubjectCellAppearence(for: collectionView, at: indexPath, isSelected: true)
            handleSubjectCellSelection(for: collectionView, at: indexPath)
        }
    }
    
    private func handleSubjectCellSelection(for collectionView: UICollectionView, at indexPath: IndexPath) {
        print(dataSource.selectSubject(for: indexPath))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            updateSubjectCellAppearence(for: collectionView, at: indexPath, isSelected: false)
            handleSubjectCellDeselection(for: collectionView, at: indexPath)
        }
    }
    
    private func handleSubjectCellDeselection(for collectionView: UICollectionView, at indexPath: IndexPath) {
        
    }
    
    private func updateSubjectCellAppearence(for collectionView: UICollectionView, at indexPath: IndexPath, isSelected: Bool) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SubjectCell else {
            preconditionFailure("Cell Register not configured correctily")
        }
        
        if isSelected {
            cell.didSelectCell()
        } else {
            cell.didDeselectCell()
        }
    }
}

extension DiscoverViewController: SynopsisCellDelegate {
    func showInfo() {
        coordinator?.showMoreInfo(viewModel: MoreInfoViewModel(bookID: "123", synopsis: "Harry Potter é um garoto órfão que vive infeliz com seus tios, os Dursleys. Ele recebe uma carta contendo um convite para ingressar em Hogwarts, uma famosa escola especializada em formar jovens…", rating: 0))
    }
    
    func discoverBook() {
        print("discorver pressed")
    }
    
    
}

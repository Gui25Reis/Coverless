//
//  DiscoverView.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 22/09/21.
//

import UIKit

final class DiscoverView: UIView, Designable {

    let collectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [ item ])
        group.edgeSpacing = .init(leading: .fixed(0), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(8))
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 18)
        let section = NSCollectionLayoutSection(group: group)
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80)),
            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(55)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        section.boundarySupplementaryItems = [header, footer]
        //section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 18.0, bottom: 0.0, trailing: 18.0)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(SynopsisCell.self,
                                forCellWithReuseIdentifier: SynopsisCell.identifier)
        collectionView.register(SubjectCollectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SubjectCollectionHeader.identifier)
        collectionView.register(DiscoverViewFooter.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: DiscoverViewFooter.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let refreshControl: UIRefreshControl
    private let loadingView: LoadingView
    
    init(designSystem: DesignSystem = DefaultDesignSystem()) {
        loadingView = LoadingView(designSystem: designSystem)
        refreshControl = UIRefreshControl()
        super.init(frame: .zero)
        setupHierarchy()
        setupLayout()
        stylize(with: designSystem)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(collectionView)
        collectionView.refreshControl = refreshControl
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setupLoadingState() {
        collectionView.backgroundView = loadingView
        loadingView.start()
    }
    
    func setupPresentationState() {
        collectionView.backgroundView = nil
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        
        loadingView.stop()
    }
    
    func setupRefreshState() {
        refreshControl.beginRefreshing()
    }
    
    func stylize(with designSystem: DesignSystem) {
        backgroundColor = designSystem.palette.backgroundPrimary
        collectionView.backgroundColor = .clear
        collectionView.accessibilityContainerType = .list
        collectionView.shouldGroupAccessibilityChildren = true
        refreshControl.tintColor = designSystem.palette.accent
        refreshControl.attributedTitle = NSAttributedString(string: "fetching more books...")
    }
    
    func bindCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }
    

}

//
//  DiscoverView.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 22/09/21.
//

import UIKit

final class DiscoverView: UIView, Designable {

    let collectionView: UICollectionView = {
        let tagItemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .estimated(30))
        let tagItem = NSCollectionLayoutItem(layoutSize: tagItemSize)
        let tagGroup = NSCollectionLayoutGroup.horizontal(layoutSize: tagItemSize, subitems: [tagItem])
        tagGroup.edgeSpacing = .init(leading: .fixed(8), top: .fixed(4), trailing: .fixed(0), bottom: .fixed(4))
        let tagSection = NSCollectionLayoutSection(group: tagGroup)
        tagSection.orthogonalScrollingBehavior = .continuous
        tagSection.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 20.0, bottom: 20.0, trailing: 20.0)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [ item ])
        group.edgeSpacing = .init(leading: .fixed(0), top: .fixed(4), trailing: .fixed(0), bottom: .fixed(4))
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0)
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                return tagSection
            case 1:
                return section
            default:
                return section
            }
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(SynopsisCell.self, forCellWithReuseIdentifier: SynopsisCell.identifier)
        collectionView.register(SubjectCell.self, forCellWithReuseIdentifier: SubjectCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(designSystem: DesignSystem = DefaultDesignSystem()) {
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
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func stylize(with designSystem: DesignSystem) {
        backgroundColor = designSystem.palette.backgroundPrimary
        collectionView.backgroundColor = .clear
        collectionView.isAccessibilityElement = false
        collectionView.shouldGroupAccessibilityChildren = true
    }
    
    func bindCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }
}

//
//  DiscoverTagsHeader.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 27/09/21.
//

import UIKit

final class DiscoverTagsHeader: UICollectionReusableView {
    
    static let dataSourceDidChangeSubject: Notification.Name = Notification.Name("Header.DiscoverTagsHeader.dataSourceDidChangeSubject")
    
    static let identifier = "DiscoverTagsHeader"
    
    private(set) lazy var tagsCollection: UICollectionView = {
        let tagItemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .estimated(30))
        let tagItem = NSCollectionLayoutItem(layoutSize: tagItemSize)
        let tagGroup = NSCollectionLayoutGroup.horizontal(layoutSize: tagItemSize, subitems: [tagItem])
        tagGroup.edgeSpacing = .init(leading: .fixed(8), top: .fixed(4), trailing: .fixed(0), bottom: .fixed(4))
        let tagSection = NSCollectionLayoutSection(group: tagGroup)
        tagSection.orthogonalScrollingBehavior = .continuous
        tagSection.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 0, bottom: 0, trailing: 0)
        let layout = UICollectionViewCompositionalLayout(section: tagSection)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    
    var carouselAccessibilityElement: CarouselAccessibilityElement?
    
    weak var dataSource: DiscoverTagsCollectionViewDataSource?
    
    override var accessibilityElements: [Any]? {
        get {
            var accessibilityElements: [Any] = []
            
            guard let currentTag = dataSource?.selectedSubject else {
                return accessibilityElements
            }
            
            let carouselAccessibilityElement: CarouselAccessibilityElement
            
            if let theCarouselAccessibilityElement = self.carouselAccessibilityElement {
                carouselAccessibilityElement = theCarouselAccessibilityElement
            } else {
                carouselAccessibilityElement = CarouselAccessibilityElement(accessibilityContainer: self, tag: currentTag)
                
                carouselAccessibilityElement.accessibilityFrameInContainerSpace = tagsCollection.frame
                
                self.carouselAccessibilityElement = carouselAccessibilityElement
            }
            
            accessibilityElements = [ carouselAccessibilityElement ]
            
            return accessibilityElements
            
        } set { }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dataSourceDidChangeSubject),
                                               name: Self.dataSourceDidChangeSubject,
                                               object: nil)
        
        addSubview(tagsCollection)
        tagsCollection.strechToBounds(of: self)
        tagsCollection.register(SubjectCell.self, forCellWithReuseIdentifier: SubjectCell.identifier)
        tagsCollection.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setup(dataSource: DiscoverTagsCollectionViewDataSource) {
        self.dataSource = dataSource
        tagsCollection.dataSource = dataSource
    }
    
    @objc
    private func dataSourceDidChangeSubject(_ notification: Notification) {
        guard
            let tag = notification.object as? Subject,
            let carouselAccessibilityElement = carouselAccessibilityElement
        else {
            return
        }
        carouselAccessibilityElement.currentTag = tag
    }
}

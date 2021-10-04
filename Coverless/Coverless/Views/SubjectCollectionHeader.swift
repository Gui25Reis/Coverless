//
//  SubjectColection.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 27/09/21.
//

import UIKit

final class SubjectCollectionHeader: UICollectionReusableView {
    
    static let identifier = "Headers.SubjectCollectionHeader"
    
    lazy var subjectCollection: UICollectionView = {
        let tagItemSize = NSCollectionLayoutSize(widthDimension: .estimated(90), heightDimension: .estimated(35))
        let tagItem = NSCollectionLayoutItem(layoutSize: tagItemSize)
        let tagGroup = NSCollectionLayoutGroup.horizontal(layoutSize: tagItemSize, subitems: [tagItem])
        tagGroup.edgeSpacing = .init(leading: .fixed(8), top: .fixed(4), trailing: .fixed(0), bottom: .fixed(4))
        let tagSection = NSCollectionLayoutSection(group: tagGroup)
        tagSection.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: tagSection)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SubjectCell.self, forCellWithReuseIdentifier: SubjectCell.identifier)
        return cv
    }()
    
    var carouselAccessibilityElement: CarouselAccessibilityElement?
    
    weak var dataSource: SubjectCollectionHeaderDataSource?
    
    private var _accessibilityElements: [Any]?
    
    override var accessibilityElements: [Any]? {
        set {
            _accessibilityElements = newValue
        } get {
            guard
                _accessibilityElements == nil,
                let selectedSubject = self.dataSource?.selectedSubject
            else { return _accessibilityElements }
            
            let carouselAccessibilityElement: CarouselAccessibilityElement
            
            if let contentViewCarouselAccessibilityElement = self.carouselAccessibilityElement {
                carouselAccessibilityElement = contentViewCarouselAccessibilityElement
            } else {
                carouselAccessibilityElement = CarouselAccessibilityElement(accessibilityContainer: self, subject: selectedSubject)
                carouselAccessibilityElement.accessibilityFrameInContainerSpace = subjectCollection.frame
                self.carouselAccessibilityElement = carouselAccessibilityElement
            }
            
            _accessibilityElements = [carouselAccessibilityElement]
            
            return _accessibilityElements
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(subjectCollection)
        subjectCollection.strechToBounds(of: self)
        NotificationCenter.default.addObserver(self, selector: #selector(subjectIsChanged), name: .didSelectSubject, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func subjectIsChanged(_ notification: Notification) {
        carouselAccessibilityElement?.currentSubject = dataSource?.selectedSubject
    }
    
    func setup(dataSource: SubjectCollectionHeaderDataSource) {
        self.dataSource = dataSource
        subjectCollection.dataSource = dataSource
        subjectCollection.delegate = dataSource
    }
}

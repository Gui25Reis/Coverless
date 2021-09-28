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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(subjectCollection)
        subjectCollection.strechToBounds(of: self)
        subjectCollection.delegate = self
        subjectCollection.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let subjects = PropertyListDecoder.decode("Subjects", to: [Subject].self) ?? []
    
    lazy var selectedSubject: Subject? = {
        if subjects.isEmpty {
            return nil
        } else {
            return subjects[0]
        }
    }() {
        didSet {
            carouselAccessibilityElement?.currentSubject = selectedSubject
        }
    }
    
    private var _accessibilityElements: [Any]?
    
    override var accessibilityElements: [Any]? {
        set {
            _accessibilityElements = newValue
        } get {
            guard
                _accessibilityElements == nil,
                let selectedSubject = self.selectedSubject
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
}
extension SubjectCollectionHeader: UICollectionViewDelegate {
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSubject = subjects[indexPath.row]
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? SubjectCell else {
            return
        }
        updateSubjectCellAppearence(cell, isSelected: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SubjectCell else {
            return
        }
        updateSubjectCellAppearence(cell, isSelected: false)
    }
    
    private func updateSubjectCellAppearence(_ cell: SubjectCell, isSelected: Bool) {
        if isSelected {
            cell.didSelectCell()
        } else {
            cell.didDeselectCell()
        }
    }

}

extension SubjectCollectionHeader: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubjectCell.identifier, for: indexPath) as? SubjectCell else {
            preconditionFailure("Cell COnfigured in a incorrect manner")
        }
        
        let isSelected = selectedSubject == subjects[indexPath.row]
        cell.setup(with: subjects[indexPath.row].name, isSelected: isSelected)
        
        return cell
    }
}

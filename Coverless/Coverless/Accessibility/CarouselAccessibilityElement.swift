//
//  CarouselAccessibilityElement.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 28/09/21.
//

import UIKit

final class CarouselAccessibilityElement: UIAccessibilityElement {
    
    var currentSubject: Subject?
    
    init(accessibilityContainer: Any, subject: Subject) {
        super.init(accessibilityContainer: accessibilityContainer)
        currentSubject = subject
    }
    
    override var accessibilityLabel: String? {
        get {
            return "Subject Picker"
        }
        set {
            super.accessibilityLabel = newValue
        }
    }

    override var accessibilityValue: String? {
        get {
            if let currentSubject = currentSubject {
                return currentSubject.name
            }

            return super.accessibilityValue
        }

        set {
            super.accessibilityValue = newValue
        }
    }

    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return .adjustable
        }
        set {
            super.accessibilityTraits = newValue
        }
    }
    
    func accessibilityScrollFoward() -> Bool {
        guard
            let containerView = accessibilityContainer as? SubjectCollectionHeader,
            let currentSubject = currentSubject,
            let subjects = PropertyListDecoder.decode("Subjects", to: [Subject].self),
            let index = subjects.firstIndex(of: currentSubject),
            index < subjects.count - 1
        else {
            return false
        }
        
        let indexPath = IndexPath(row: index+1, section: 0)
        containerView.subjectCollection.scrollToItem(at: indexPath,
                                                     at: .centeredHorizontally,
                                                     animated: true)
        containerView.subjectCollection.selectItem(at: indexPath,
                                                   animated: true,
                                                   scrollPosition: .centeredHorizontally)
        containerView.subjectCollection.delegate?.collectionView?(containerView.subjectCollection, didSelectItemAt: indexPath)
        containerView.subjectCollection.delegate?.collectionView?(containerView.subjectCollection, didDeselectItemAt: IndexPath(row: index, section: 0))
        
        return true
    }
    
    func accessibilityScrollBackward() -> Bool {
        guard
            let containerView = accessibilityContainer as? SubjectCollectionHeader,
            let currentSubject = currentSubject,
            let subjects = PropertyListDecoder.decode("Subjects", to: [Subject].self),
            let index = subjects.firstIndex(of: currentSubject),
            index > 0
        else { return false }
        
        let indexPath = IndexPath(row: index-1, section: 0)
        containerView.subjectCollection.scrollToItem(at: indexPath,
                                                     at: .centeredHorizontally,
                                                     animated: true)
        containerView.subjectCollection.selectItem(at: indexPath,
                                                   animated: true,
                                                   scrollPosition: .centeredHorizontally)
        containerView.subjectCollection.delegate?.collectionView?(containerView.subjectCollection, didSelectItemAt: indexPath)
        containerView.subjectCollection.delegate?.collectionView?(containerView.subjectCollection, didDeselectItemAt: IndexPath(row: index, section: 0))
        
        return true
    }
    
    override func accessibilityIncrement() {
        _ = accessibilityScrollFoward()
    }
    
    override func accessibilityDecrement() {
        _ = accessibilityScrollBackward()
    }
    
    override func accessibilityScroll(_ direction: UIAccessibilityScrollDirection) -> Bool {
        if direction == .left {
            return accessibilityScrollFoward()
        } else if direction == .right {
            return accessibilityScrollBackward()
        }
        return false
    }
    
}

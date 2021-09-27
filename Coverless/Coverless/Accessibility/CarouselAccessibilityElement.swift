//
//  CarouselAccessibilityElement.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 27/09/21.
//

import UIKit

final class CarouselAccessibilityElement: UIAccessibilityElement {
    
    var currentTag: Subject?
    
    init(accessibilityContainer container: Any, tag: Subject?) {
        super.init(accessibilityContainer: container)
        currentTag = tag
    }
    
    override var accessibilityLabel: String? {
        get {
            return "Tag Selector"
        } set {}
    }
    
    override var accessibilityValue: String? {
        get {
            if let currentTag = currentTag {
                return currentTag.name
            } else {
                return super.accessibilityValue
            }
        } set {
            super.accessibilityValue = newValue
        }
    }
    
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return .adjustable
        } set {}
    }
    
    override func accessibilityIncrement() {
        _ = accessibilityScrollCollectionView(forwards: true)
    }
    
    override func accessibilityDecrement() {
        _ = accessibilityScrollCollectionView(forwards: false)
    }
    
    private func accessibilityScrollCollectionView(forwards: Bool) -> Bool {
        guard
            let containerView = accessibilityContainer as? DiscoverTagsHeader,
            let dataSource = containerView.tagsCollection.dataSource as? DiscoverTagsCollectionViewDataSource
        else {
            return false
        }
        
        guard let currentTag = currentTag else { return false }
        let tags = dataSource.subjects
        
        if forwards {
            guard let index = tags.firstIndex(of: currentTag), index < tags.count - 1 else {
                return false
            }
            
            containerView.tagsCollection.scrollToItem(at: IndexPath(row: index+1, section: 0),
                                                      at: .centeredHorizontally,
                                                      animated: true)
        } else {
            guard let index = tags.firstIndex(of: currentTag), index > 0
            else { return true }
            
            containerView.tagsCollection.scrollToItem(at: IndexPath(row: index - 1, section: 0),
                                                      at: .centeredHorizontally,
                                                      animated: true)
        }
        
        return true
    }
}

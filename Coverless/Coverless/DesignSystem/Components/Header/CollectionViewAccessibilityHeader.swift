//
//  CollectionViewAccessibilityHeader.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 24/09/21.
//

import UIKit

final class CollectionViewAccessibilityHeader: UICollectionReusableView {
    
    static let identifier: String = "Coverless.UICollectionReusableView.CollectionViewAccessibilityHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isAccessibilityElement = true
        accessibilityTraits = .header
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAccessibilityLabel(with value: String) {
        accessibilityLabel = value
    }
    
    
}

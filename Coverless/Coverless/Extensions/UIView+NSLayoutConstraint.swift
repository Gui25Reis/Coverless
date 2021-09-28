//
//  UIView+NSLayoutConstraint.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 20/09/21.
//

import UIKit

protocol Stretchable {
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
}

extension UIView: Stretchable {}
extension UILayoutGuide: Stretchable {}

extension UIView {
    
    @discardableResult
    func strechToBounds(of view: Stretchable) -> [NSLayoutConstraint] {
        let constraints = [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        return constraints
    }
}

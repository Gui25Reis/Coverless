//
//  NSLayoutAnchor+DesignSystem.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 16/09/21.
//

import UIKit

extension NSLayoutYAxisAnchor{
    func constraint(equalTo anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: KeyPath<DesignSpacing,CGFloat>) -> NSLayoutConstraint {
        constraint(equalTo: anchor, constant: DefaultDesignSystem.shared.spacing[keyPath: constant])
    }
}
extension NSLayoutXAxisAnchor{
    func constraint(equalTo anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: KeyPath<DesignSpacing,CGFloat>) -> NSLayoutConstraint {
        constraint(equalTo: anchor, constant: DefaultDesignSystem.shared.spacing[keyPath: constant])
    }
}

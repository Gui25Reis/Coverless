//
//  UIImageView+TraitCollection.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 15/09/21.
//

import UIKit

extension UIImageView {
    func setSymbolConfiguration(for traitCollection: UITraitCollection) {
        guard let image = image else { return }
        self.image = image.withConfiguration(image.getSymbolConfiguration(for: traitCollection))
    }
}

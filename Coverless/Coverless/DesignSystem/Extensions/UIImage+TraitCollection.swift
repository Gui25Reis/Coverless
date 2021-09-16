//
//  UIImage+TraitCollection.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 16/09/21.
//

import UIKit

extension UIImage {
    func getSymbolConfiguration(for traitCollection: UITraitCollection) -> UIImage.SymbolConfiguration {
        
        if traitCollection.preferredContentSizeCategory <= .small {
            return SymbolAccesibilityConfiguration.small.configuration
        } else if traitCollection.preferredContentSizeCategory <= .accessibilityMedium {
            return SymbolAccesibilityConfiguration.medium.configuration
        } else if traitCollection.preferredContentSizeCategory <= .accessibilityLarge {
            return SymbolAccesibilityConfiguration.large.configuration
        } else {
            return SymbolAccesibilityConfiguration.xLarge.configuration
        }
    }
}

//
//  SymbolAccesibilityConfiguration.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 15/09/21.
//

import UIKit

enum SymbolAccesibilityConfiguration {
    case small, medium, large, xLarge
    
    var configuration: UIImage.SymbolConfiguration {
        switch self {
        case .xLarge:
            return .init(pointSize: 25)
        case .large:
            return .init(pointSize: 22)
        case .medium:
            return .init(pointSize: 17)
        case .small:
            return .init(pointSize: 12)
        }
    }
}

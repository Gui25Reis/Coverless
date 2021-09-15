//
//  DesignSystem.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 15/09/21.
//

import Foundation

protocol DesignSystem {
    var palette: DesignPalette { get }
    var spacing: DesignSpacing { get }
}

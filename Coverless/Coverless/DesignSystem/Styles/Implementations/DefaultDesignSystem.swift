//
//  DesignSystem.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 14/09/21.
//

import UIKit

struct DefaultDesignSystem: DesignSystem {
    let text: DesignText = DesignText()
    let palette: DesignPalette = DefaultDesignPalette()
    let spacing: DesignSpacing = DefaultDesignSpacing()
    static var shared: DesignSystem = DefaultDesignSystem()
}



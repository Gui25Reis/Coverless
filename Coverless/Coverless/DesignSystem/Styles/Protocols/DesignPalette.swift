//
//  DesignPalette.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 15/09/21.
//

import UIKit

protocol DesignPalette {
    var backgroundPrimary: UIColor { get }
    var accent: UIColor { get }
    var textPrimary: UIColor { get }
    var titlePrimary: UIColor { get }
    var backgroundCell: UIColor { get }
}

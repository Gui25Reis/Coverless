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
    var readColor: UIColor { get }
    var readingColor: UIColor { get }
    var wantColor: UIColor { get }
    var buttonTextPrimary: UIColor { get }
    var buttonBackgroundPrimary: UIColor { get }
}

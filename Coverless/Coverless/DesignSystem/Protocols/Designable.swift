//
//  Designable.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 14/09/21.
//

import UIKit

protocol Designable: UIView {
    func stylize(with designSystem: DesignSystem)
}

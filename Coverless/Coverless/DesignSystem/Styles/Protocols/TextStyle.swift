//
//  TextStyle.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 15/09/21.
//

import UIKit

protocol TextStyle {
    
    var font: UIFont { get }
    var color: UIColor { get }
    var alignment: NSTextAlignment { get }
}

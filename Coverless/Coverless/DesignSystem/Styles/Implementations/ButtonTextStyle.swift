//
//  ButtonTextStyle.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 15/09/21.
//

import UIKit

struct ButtonTextStyle: TextStyle {
    var font: UIFont = .preferredFont(forTextStyle: .caption1)
    
    var color: UIColor = .accent
    
    var alignment: NSTextAlignment = .center
}

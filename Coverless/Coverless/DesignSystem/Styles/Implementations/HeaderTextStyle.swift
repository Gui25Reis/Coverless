//
//  HeaderTextStyle.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 20/09/21.
//

import UIKit

struct HeaderTextStyle: TextStyle {
    var font: UIFont = {
        let descritor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline)
        return UIFont(descriptor: descritor, size: 0)
    }()
    var color: UIColor = .titlePrimary
    var alignment: NSTextAlignment = .left
}

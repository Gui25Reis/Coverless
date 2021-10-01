//
//  LargeTitleTextStyle.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 30/09/21.
//

import UIKit

struct LargeTitleTextStyle: TextStyle {
    var font: UIFont = {
        let descritor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
        if let bold = descritor.withSymbolicTraits(.traitBold) {
            return UIFont(descriptor: bold, size: 0)
        }
        return UIFont(descriptor: descritor, size: 0)
    }()
    var color: UIColor = .titlePrimary
    var alignment: NSTextAlignment = .center
}

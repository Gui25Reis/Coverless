//
//  LargeSerifTextStyle.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 30/09/21.
//

import UIKit

struct LargeSerifTextStyle: TextStyle {
    var font: UIFont = {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
        if let serif = descriptor.withDesign(.serif)?.withSymbolicTraits(.traitBold){
            return UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: UIFont(descriptor: serif, size: 0))
        }
        return UIFont(descriptor: descriptor, size: 0)
    }()
    var color: UIColor = .titlePrimary
    var alignment: NSTextAlignment = .center
}

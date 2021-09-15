//
//  BodyTextStyle.swift
//  Coverless
//
//  Created by Beatriz Duque on 15/09/21.
//

import UIKit

struct BodyTextStyle: TextStyle{
    var font: UIFont = {
        let descriptor = UIFont.systemFont(ofSize: 17).fontDescriptor
        if let serif = descriptor.withDesign(.serif){
            return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(descriptor: serif, size: 0))
        }
        return UIFont.init(descriptor: descriptor, size: 0)
    }()
    
    var color: UIColor = .textPrimary
    
    var alignment: NSTextAlignment = .natural
}

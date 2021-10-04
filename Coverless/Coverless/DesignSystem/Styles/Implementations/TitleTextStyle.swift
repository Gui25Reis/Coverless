//
//  TitleTextStyle.swift
//  Coverless
//
//  Created by Beatriz Duque on 17/09/21.
//

import UIKit

struct TitleTextStyle: TextStyle {
    var font: UIFont = .preferredFont(forTextStyle: .headline)
    var color: UIColor = .titlePrimary
    var alignment: NSTextAlignment = .natural
}

//
//  SynopsisCellButton.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 14/09/21.
//

import UIKit

final class SynopsisCellButton: UIButton, Designable {
    
    let label = UILabel(frame: .zero)
    let symbolView = UIImageView(frame: .zero)
    
    init(text: String, systemName: String, designSystem: DesignSystem = DefaultDesignSystem())  {
        super.init(frame: .zero)
        
        let symbol = UIImage(systemName: systemName)
        
        if let symbol = symbol {
            symbolView.contentMode = .scaleAspectFit
            symbolView.image = symbol
                .applyingSymbolConfiguration(symbol.getSymbolConfiguration(for: traitCollection))
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        symbolView.translatesAutoresizingMaskIntoConstraints = false
        symbolView.isUserInteractionEnabled = false
        
        addSubview(label)
        addSubview(symbolView)
        
        NSLayoutConstraint.activate([
            symbolView.leadingAnchor.constraint(equalTo: leadingAnchor),
            symbolView.trailingAnchor.constraint(equalTo: trailingAnchor),
            symbolView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: \.xSmallPositive),
            symbolView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.40),
            label.topAnchor.constraint(equalTo: centerYAnchor, constant: \.smallPositive),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        label.text = text
        label.numberOfLines = 0
        stylize(with: designSystem)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stylize(with designSystem: DesignSystem) {
        symbolView.tintColor = designSystem.palette.accent
        label.stylize(with: designSystem.text.button)
        
        adjustsImageSizeForAccessibilityContentSizeCategory = true
        symbolView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        label.adjustsFontForContentSizeCategory = true
    }
}

//
//  SynopsisCellButton.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 14/09/21.
//

import UIKit

final class SynopsisCellButton: UIButton, Designable {
    
    let label = UILabel(frame: .zero)
    var action: (() -> Void)?
    
    init(text: String, systemName: String, designSystem: DesignSystem = DefaultDesignSystem())  {
        super.init(frame: .zero)
        let configuarion = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: systemName, withConfiguration: configuarion)
        setImage(image, for: .normal)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView!.bottomAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        label.text = text
        label.numberOfLines = 0
        stylize(with: designSystem)
        addAction(UIAction(handler: {[weak self] _ in
            guard
                let self = self,
                let action = self.action
            else { return }
            action()
        }), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stylize(with designSystem: DesignSystem) {
        imageView?.tintColor = designSystem.palette.accent
        label.stylize(with: designSystem.text.button)
        
        adjustsImageSizeForAccessibilityContentSizeCategory = true
        imageView!.adjustsImageSizeForAccessibilityContentSizeCategory = true
        label.adjustsFontForContentSizeCategory = true
    }
}

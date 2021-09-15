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
    
    init(text: String, systemName: String, designSystem: DesignSystem) {
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
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        label.text = text
        stylize(with: designSystem)
        backgroundColor = .blue.withAlphaComponent(0.4)
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
        label.textColor = designSystem.palette.accent
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 12))
        //DS
        label.textAlignment = .center
        
        adjustsImageSizeForAccessibilityContentSizeCategory = true
        imageView?.adjustsImageSizeForAccessibilityContentSizeCategory = true
        label.adjustsFontForContentSizeCategory = true
    }
}

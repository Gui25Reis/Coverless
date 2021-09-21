//
//  StatusButton.swift
//  Coverless
//
//  Created by Beatriz Duque on 19/09/21.
//

import UIKit

enum BookStatus: Int{
    case read,reading,abandoned
}


final class StatusButton: UIButton, Designable {
    
    let label = UILabel(frame: .zero)
    public var status: BookStatus
    
    init(designSystem: DesignSystem = DefaultDesignSystem())  {
        self.status = .reading //inicia como reading por default
        super.init(frame: .zero)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: centerYAnchor, constant: \.smallNegative),
            label.leadingAnchor.constraint(equalTo: leadingAnchor,constant: \.mediumPositive),
            label.trailingAnchor.constraint(equalTo: trailingAnchor,constant: \.mediumNegative)
        ])
        
        //label.text = text
        label.numberOfLines = 0
        stylize(with: designSystem)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setStatus(status: BookStatus,designSystem: DesignSystem = DefaultDesignSystem()){
        if status == .read{
            self.tintColor = designSystem.palette.readColor
            //self.setTitle("Lido", for: .normal)
            label.text = "Lido"
            label.textColor = designSystem.palette.readColor
            //self.setTitleColor(designSystem.palette.readColor, for: .normal)
            self.backgroundColor = designSystem.palette.backgroundPrimary
        }
        else if status  == .reading{
            self.tintColor = designSystem.palette.readingColor
            //self.setTitle("Estou lendo", for: .normal)
            label.text = "Estou lendo"
            label.textColor = designSystem.palette.readingColor
            //self.setTitleColor(designSystem.palette.readingColor, for: .normal)
            self.backgroundColor = designSystem.palette.backgroundPrimary
            
        }
        else{
            self.tintColor = designSystem.palette.abandonedColor
            //self.setTitle("Abandonado", for: .normal)
            label.text = "Abandonado"
            label.textColor = designSystem.palette.abandonedColor
            //self.setTitleColor(designSystem.palette.abandonedColor, for: .normal)
            self.backgroundColor = designSystem.palette.backgroundPrimary
        }
    }
    func stylize(with designSystem: DesignSystem) {
        self.layer.cornerRadius = 15
        //label.textColor = .accent

        //acessibilidade
        adjustsImageSizeForAccessibilityContentSizeCategory = true
        label.adjustsFontForContentSizeCategory = true
    }
}


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
    public var status: BookStatus
    
    init(designSystem: DesignSystem = DefaultDesignSystem())  {
        self.status = .reading //inicia como reading por default
        super.init(frame: .zero)
        stylize(with: designSystem)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setStatus(status: BookStatus,designSystem: DesignSystem = DefaultDesignSystem()){
        if status == .read{
            setButtonStyle(color: designSystem.palette.readColor, text: "Lido")
        }
        else if status  == .reading{
            setButtonStyle(color: designSystem.palette.readingColor, text: "Estou lendo")
        }
        else{
            setButtonStyle(color: designSystem.palette.abandonedColor, text: "Abandonado")
        }
        
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
        
        titleLabel?.font = UIFont(descriptor: descriptor, size: 0)
    }
    
    private func setButtonStyle(color: UIColor, text: String) {
        setTitle(text, for: .normal)
        setTitleColor(color, for: .normal)
        self.backgroundColor = color.withAlphaComponent(0.15)
    }
    
    func stylize(with designSystem: DesignSystem) {
        self.layer.cornerRadius = 15
        //label.textColor = .accent

        //acessibilidade
        adjustsImageSizeForAccessibilityContentSizeCategory = true
        titleLabel?.adjustsFontForContentSizeCategory = true
    }
}


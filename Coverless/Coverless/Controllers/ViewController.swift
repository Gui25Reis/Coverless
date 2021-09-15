//
//  ViewController.swift
//  Coverless
//
//  Created by Gui Reis on 14/09/21.
//

import UIKit

class MenuViewController: UIViewController {
    
    let designSystem: DesignSystem = DefaultDesignSystem()
    
    /* MARK: - Ciclo de Vida */
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
        let button = SynopsisCellButton(text: "Descubra", systemName: "plus", designSystem: designSystem)
        
        let imageText = UIImageView(image: .init(systemName: "plus"))
        
        button.translatesAutoresizingMaskIntoConstraints = false
        imageText.translatesAutoresizingMaskIntoConstraints = false
        
        imageText.adjustsImageSizeForAccessibilityContentSizeCategory = true
        
        view.addSubview(button)
        view.addSubview(imageText)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageText.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 16)
        ])
        
        
        
        view.backgroundColor = .secondarySystemBackground
    }
    
    
    
    /* MARK: - Configurações */
    
    // Coloque aqui as funções de consfigurações em geral
    
    
    
    /* MARK: - Ações dos botões */
    
    // Coloque aqui as açòes dos botões da view
    
}

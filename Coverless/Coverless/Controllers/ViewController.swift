//
//  ViewController.swift
//  Coverless
//
//  Created by Gui Reis on 14/09/21.
//

import UIKit

class MenuViewController: UIViewController {
    
    private let api = BookRepository()
    private var button:UIButton!
    
    
    /* MARK: - Civlo de Vida */
    public override func loadView() -> Void {
        super.loadView()
        
        self.view.backgroundColor = .systemGray3
        
        let button:UIButton = {
            let bt = UIButton()
            bt.backgroundColor = .systemBlue
            bt.translatesAutoresizingMaskIntoConstraints = false
            return bt
        }()
        
        button.addTarget(self, action: #selector(self.buttonAction), for: .touchDown)
        
        self.button = button
        self.view.addSubview(self.button)
    }
    
    
    public override func viewDidLayoutSubviews() -> Void {
        super.viewDidLayoutSubviews()
        
        let size:CGFloat = 200
        
        self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: size).isActive = true
        self.button.widthAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    
    
    /* MARK: - Configurações */
    private func success(_ books:[Book]) -> Void {
        for b in books {
            print("Id: \(b.id)")
            print("Title: \(b.title)")
            print("Sinopse: \(b.description)\n\n")
        }
        
        print("===== Total de livros: \(books.count) =====\n")
    }
    
    
    
    
    /* MARK: - Ação do botão */
    
    @objc func buttonAction() -> Void {
        
        api.getRandomizedBooks() { result in
            
            switch result {
                case .success(let book):
                    self.success(book)
                    break
                    
                case .failure(let error):
                    print("Erro API: \(error)")
                    break
                    
            }
            
        }
    }
}

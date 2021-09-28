//
//  EmptyView.swift
//  Coverless
//
//  Created by Beatriz Duque on 28/09/21.
//

import UIKit

class EmptyView: UIView{
    let designSystem: DesignSystem
    private let imageBook:UIImageView
    public let emptyText: UILabel
    public let discoverButton: UIButton
    
    weak var coordinator: DiscoverCoordinator?

    
    private lazy var constraintsDefault = [
        imageBook.topAnchor.constraint(equalTo: self.topAnchor,constant: \.largePositive),
        imageBook.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
        imageBook.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
        imageBook.bottomAnchor.constraint(equalTo: emptyText.topAnchor,constant: \.largeNegative),
        imageBook.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        
        emptyText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: \.largePositive),
        emptyText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: \.largeNegative),
        emptyText.bottomAnchor.constraint(equalTo: discoverButton.topAnchor, constant: \.xLargeNegative),
        
        discoverButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        discoverButton.heightAnchor.constraint(equalToConstant: 40),
        discoverButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4)
    ]
    
    
    init() {
        imageBook = UIImageView()
        emptyText = UILabel()
        discoverButton = UIButton()
        designSystem = DefaultDesignSystem()
        super.init(frame: .zero)
        
        addSubview(imageBook)
        addSubview(emptyText)
        addSubview(discoverButton)

        
        setupLayout()
        stylize(with: designSystem)
        activateConstraints()
        setupActions()

    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    func setupLayout(){
        ///imagem
        imageBook.image = UIImage(named: "ImageBookDefault")!
        imageBook.translatesAutoresizingMaskIntoConstraints = false
        emptyText.translatesAutoresizingMaskIntoConstraints = false
        discoverButton.translatesAutoresizingMaskIntoConstraints = false

        ///botao
        discoverButton.backgroundColor = designSystem.palette.buttonBackgroundPrimary
        discoverButton.setTitle("Discover Book", for: .normal)
        discoverButton.setTitleColor(designSystem.palette.buttonTextPrimary, for: .normal)
        discoverButton.layer.cornerRadius = 8
        
        ///texto
        emptyText.text = "No books discovered on the shelf. Let's discover a new one?"
        emptyText.numberOfLines = 0
    }
    
    func stylize(with designSystem: DesignSystem) {
        emptyText.stylize(with: designSystem.text.body)
        setAccessibility()
    }
    
    func activateConstraints(){
        NSLayoutConstraint.activate(constraintsDefault)
    }
    
    func setAccessibility(){
        
    }
    
    private func setupActions() {
        discoverButton.addTarget(self, action: #selector(discoverButtonSelected), for: .touchUpInside)
    }
    
    @objc
    private func discoverButtonSelected() {
        print("Discover book pressioned")
        //coordinator?.start()
    }
}

//
//  EmptyView.swift
//  Coverless
//
//  Created by Beatriz Duque on 28/09/21.
//

import UIKit

class EmptyView: UIView{
    let designSystem: DesignSystem
    private let imageBook: ImageBook
    private let emptyText: UILabel
    private let discoverButton: UIButton
    private let scrollView: UIScrollView
    
    public weak var delegate: EmptyViewDelegate? = nil

    /* MARK: - Configurando constraints */
    private lazy var constraintsDefault = [
        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
        scrollView.topAnchor.constraint(equalTo: self.topAnchor),
        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
        scrollView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -100),
        
        imageBook.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: \.largePositive),
        imageBook.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.6),
        imageBook.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.4),
        imageBook.bottomAnchor.constraint(equalTo: emptyText.topAnchor,constant: \.largeNegative),
        imageBook.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        
        emptyText.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: \.largePositive),
        emptyText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: \.largeNegative),
        emptyText.bottomAnchor.constraint(equalTo: discoverButton.topAnchor, constant: \.xLargeNegative),
        
        discoverButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        discoverButton.heightAnchor.constraint(equalToConstant: 40),
        discoverButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.4),
        discoverButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: \.smallNegative)
    ]
    
    
    init() {
        imageBook = ImageBook(image: UIImage(named: "ImageBookDefault")!)
        scrollView = UIScrollView()
        emptyText = UILabel()
        discoverButton = UIButton()
        designSystem = DefaultDesignSystem()
        super.init(frame: .zero)
        addSubview(scrollView)
        scrollView.addSubview(imageBook)
        scrollView.addSubview(emptyText)
        scrollView.addSubview(discoverButton)

        
        setupLayout()
        stylize(with: designSystem)
        activateConstraints()
        setupActions()

    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    func setupLayout(){
        ///imagem
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageBook.translatesAutoresizingMaskIntoConstraints = false
        emptyText.translatesAutoresizingMaskIntoConstraints = false
        discoverButton.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.isScrollEnabled = true
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
        emptyText.isAccessibilityElement = true
        discoverButton.isAccessibilityElement = true
        discoverButton.accessibilityHint = "Click to open Discover screen"
    }
    
    private func setupActions() {
        discoverButton.addTarget(self, action: #selector(discoverButtonSelected), for: .touchUpInside)
    }
    
    @objc
    private func discoverButtonSelected() {
        guard let delegate = delegate else { return }
        delegate.toDiscover()
    }
}



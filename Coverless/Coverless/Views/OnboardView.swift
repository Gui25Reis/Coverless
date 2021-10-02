//
//  OnboardView.swift
//  Coverless
//
//  Created by Beatriz Duque on 02/10/21.
//

import UIKit
class ViewOnboarding:UIView{
    
    private let designSystem: DesignSystem
    private let scrollView: UIScrollView
    public let labelTitulo = UILabel()
    public let label = UILabel()
    var imageName = String()
    
    lazy var image = UIImage(named: imageName)
    lazy var imageView = UIImageView(image: image!)
    
    init(titulo:String,text:String,imageName:String){
        self.designSystem = DefaultDesignSystem()
        self.scrollView = UIScrollView()
        
        super.init(frame: .zero)
        self.addSubview(scrollView)
        self.backgroundColor = .backgroundPrimary

        labelTitulo.text = titulo
        scrollView.addSubview(labelTitulo)
        
        label.text = text
        label.numberOfLines = 0
        scrollView.addSubview(label)
        
        self.imageName = imageName
        scrollView.addSubview(imageView)
        stylize(with: designSystem)
        setupConstrainstsOnbarding()
        
        setAccessibility()

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstrainstsOnbarding(){
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollConstraints:[NSLayoutConstraint] = [
        scrollView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
        scrollView.topAnchor.constraint(equalTo: self.topAnchor),
        scrollView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        scrollView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -200)]
        NSLayoutConstraint.activate(scrollConstraints)

        
        labelTitulo.translatesAutoresizingMaskIntoConstraints = false
        let labelTituloConstraints:[NSLayoutConstraint] = [
            labelTitulo.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: \.largePositive),
            labelTitulo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            labelTitulo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            labelTitulo.bottomAnchor.constraint(equalTo: label.topAnchor, constant: \.mediumNegative)
        ]
        NSLayoutConstraint.activate(labelTituloConstraints)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        let labelConstraints:[NSLayoutConstraint] = [
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            label.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: \.largeNegative)
        ]
        NSLayoutConstraint.activate(labelConstraints)
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imgConstrainsts:[NSLayoutConstraint] = [
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor,multiplier: 0.5),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: \.smallNegative)
        ]
        NSLayoutConstraint.activate(imgConstrainsts)
        
        
    }
    func stylize(with designSystem: DesignSystem) {
        labelTitulo.stylize(with: designSystem.text.largeSerif)
        label.stylize(with: designSystem.text.body)
    }
    func setAccessibility(){
        labelTitulo.isAccessibilityElement = true
        label.isAccessibilityElement = true
        imageView.isAccessibilityElement = false
    }
}


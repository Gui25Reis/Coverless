//
//  ImageBook.swift
//  Coverless
//
//  Created by Beatriz Duque on 19/09/21.
//

import UIKit

class ImageBook: UIView {
    private let imageView: UIImageView
    private lazy var constraintsDefault = [
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor),
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor)
    ]
    
    init() {
        imageView = UIImageView()
        super.init(frame: .zero)
        style()
        addSubview(imageView)
        activateConstraints()
        
        
    }
    //passar uma imagem pro init
    init(image: UIImage?){
        imageView = UIImageView()
        imageView.image = image
        super.init(frame: .zero)
        style()
        addSubview(imageView)
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(with image: UIImage?) {
        imageView.image = image
    }
    
    func style(){
        layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.clipsToBounds = true
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 14.5
        layer.cornerRadius = 14.5
    }
    func activateConstraints(){
        NSLayoutConstraint.activate(constraintsDefault)
    }
}


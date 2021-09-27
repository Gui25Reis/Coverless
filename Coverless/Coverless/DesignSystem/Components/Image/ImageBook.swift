//
//  ImageBook.swift
//  Coverless
//
//  Created by Beatriz Duque on 19/09/21.
//

import UIKit

class ImageBook: UIView {
    private let imageView: UIImageView
    
    //passar uma imagem pro init
    init() {
        imageView = UIImageView()
        super.init(frame: .zero)
        style()
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func style(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        layer.cornerRadius = 14.5
    }
}


//
//  AsyncImage.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 01/10/21.
//

import UIKit

final class AsyncImage: UIView {
    
    private let imageView: UIImageView
    private let loadingView: LoadingView
    
    init(url: URL?, designSystem: DesignSystem) {
        imageView = UIImageView()
        loadingView = LoadingView(designSystem: designSystem)
        loadingView.backgroundColor = designSystem.palette.backgroundCell
        super.init(frame: .zero)
        setupHierarchy()
        setupLayout()
        setupStyle()
        
        if let url = url {
            load(from: url)
        } else {
            setDefaultPlaceholder()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(imageView)
        addSubview(loadingView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        imageView.strechToBounds(of: self)
        loadingView.strechToBounds(of: layoutMarginsGuide)
    }
    
    private func setupStyle() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        loadingView.clipsToBounds = true
        hideImageAndShowLoading()
        clipsToBounds = true
        layer.cornerRadius = 12
    }
    
    private func setupAccessibility() {
        imageView.isAccessibilityElement = false
        loadingView.isAccessibilityElement = false
        isAccessibilityElement = true
    }
    
    private func hideImageAndShowLoading() {
        imageView.isHidden = true
        loadingView.isHidden = false
        loadingView.start()
    }
    
    private func load(from url: URL) {
        URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self.setDefaultPlaceholder()
                }
            }
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let data = data {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.setImageView(with: image)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.setDefaultPlaceholder()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.setDefaultPlaceholder()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.setDefaultPlaceholder()
                }
            }
        }.resume()
    }
    
    func setDefaultPlaceholder() {
        hideLoadingAndShowImage()
        imageView.image = UIImage(named: "ImageBookDefault")
    }
    
    func setImageView(with image: UIImage) {
        hideLoadingAndShowImage()
        imageView.image = image
    }
    
    private func hideLoadingAndShowImage() {
        loadingView.stop()
        loadingView.isHidden = true
        imageView.isHidden = false
    }
}

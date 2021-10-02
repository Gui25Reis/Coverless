//
//  DiscoveredBookView.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 30/09/21.
//

import UIKit

final class DiscoveredBookView: UIView {
    
    private let imageView: AsyncImage
    private let discoverLabel: UILabel
    private let bookTitle: UILabel
    
    init(designSystem: DesignSystem, book: Book) {
        self.imageView = AsyncImage(url: URL(string: book.image), designSystem: designSystem)
        self.discoverLabel = UILabel()
        self.bookTitle = UILabel()
        super.init(frame: .zero)
        setupHierarchy()
        setupLayout()
        setupStyle(with: designSystem, book: book)
    }
    
    func setupHierarchy() {
        addSubview(imageView)
        addSubview(discoverLabel)
        addSubview(bookTitle)
    }
    
    func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageConstraints: [NSLayoutConstraint] = [
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            
        ]
        
        NSLayoutConstraint.activate(imageConstraints)
        
        discoverLabel.translatesAutoresizingMaskIntoConstraints = false
        let discoverLabelConstraints: [NSLayoutConstraint] = [
            discoverLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: \.largePositive),
            discoverLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            discoverLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            discoverLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: \.largeNegative)
        ]
        
        NSLayoutConstraint.activate(discoverLabelConstraints)
        
        bookTitle.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelConstraints: [NSLayoutConstraint] = [
            bookTitle.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: \.xLargeNegative),
            bookTitle.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            bookTitle.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    func setupStyle(with designSystem: DesignSystem, book: Book) {
        backgroundColor = designSystem.palette.backgroundPrimary
        discoverLabel.stylize(with: designSystem.text.largeTitle)
        bookTitle.stylize(with: designSystem.text.largeSerif)
        bookTitle.numberOfLines = 0
        discoverLabel.numberOfLines = 0
        discoverLabel.text = "Discovered Book"
        bookTitle.text = "Really Huge to title to see how it's gonna behave"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class AsyncImage: UIView {
    
    private let imageView: UIImageView
    private let loadingView: LoadingView
    
    init(url: URL?, designSystem: DesignSystem) {
        imageView = UIImageView()
        loadingView = LoadingView(designSystem: designSystem)
        loadingView.backgroundColor = designSystem.palette.backgroundCell
        super.init(frame: .zero)
        backgroundColor = .red
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
        loadingView.strechToBounds(of: self)
    }
    
    private func setupStyle() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        loadingView.clipsToBounds = true
        hideImageAndShowLoading()
        clipsToBounds = true
        layer.cornerRadius = 12
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
        imageView.image = .remove
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

#if(DEBUG)
import SwiftUI

struct DiscoveredBookView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            AnyViewRepresentable(DiscoveredBookView(designSystem: DefaultDesignSystem(), book: Book(id: "", isbn10: "", title: "Harry Potter", description: "", image: "https://books.google.com/books/content?id=-bF2CwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api", author: "", publisher: "", buyLinks: [:])))
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            AnyViewRepresentable(AsyncImage(url: URL(string: "https://books.google.com/books/content?id=x605AwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"), designSystem: DefaultDesignSystem()))
        }
    }
}
#endif

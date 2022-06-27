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
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var stackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.translatesAutoresizingMaskIntoConstraints = false
        stv.distribution = .equalSpacing
        stv.alignment = .fill
        stv.spacing = 42
        stv.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        stv.isLayoutMarginsRelativeArrangement = true
        return stv
    }()
    
    init(designSystem: DesignSystem, book: Book) {
        self.imageView = AsyncImage(url: URL(string: book.image ?? ""), designSystem: designSystem)
        self.discoverLabel = UILabel()
        self.bookTitle = UILabel()
        super.init(frame: .zero)
        setupHierarchy()
        setupLayout()
        setupStyle(with: designSystem, book: book)
        setupAccessibility()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(discoverLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(bookTitle)
    }
    
   private func setupLayout() {
        
        scrollView.strechToBounds(of: layoutMarginsGuide)
        contentView.strechToBounds(of: scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.strechToBounds(of: contentView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageConstraints: [NSLayoutConstraint] = [
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
            
        ]
        
        NSLayoutConstraint.activate(imageConstraints)
    }
    
    private func setupStyle(with designSystem: DesignSystem, book: Book) {
        backgroundColor = designSystem.palette.backgroundPrimary
        discoverLabel.stylize(with: designSystem.text.largeTitle)
        bookTitle.stylize(with: designSystem.text.largeSerif)
        discoverLabel.text = "Discovered Book"
        discoverLabel.accessibilityLabel = "Discovered Book"
        bookTitle.text = book.title
        bookTitle.accessibilityLabel = book.title
        
    }
    
    private func setupAccessibility() {
        discoverLabel.isAccessibilityElement = true
        discoverLabel.accessibilityTraits = .header
        discoverLabel.numberOfLines = 0
        
        bookTitle.isAccessibilityElement = true
        bookTitle.accessibilityTraits = .staticText
        bookTitle.numberOfLines = 0
        
        imageView.isAccessibilityElement = true
        imageView.accessibilityTraits = .image
        imageView.accessibilityLabel = "Book Cover"
        
        accessibilityElements = [discoverLabel, imageView, bookTitle]
    }
    
    
}

/*
#if(DEBUG)
import SwiftUI

struct DiscoveredBookView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            AnyViewRepresentable(DiscoveredBookView(designSystem: DefaultDesignSystem(), book: Book(id: "", isbn10: "", title: "Harry Potter", description: "", image: "https://books.google.com/books/content?id=-bF2CwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api", author: "", publisher: "", buyLinks: [:])))
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        }
    }
}
#endif
*/

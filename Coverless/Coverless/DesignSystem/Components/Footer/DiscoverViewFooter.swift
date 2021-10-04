//
//  DiscoverViewFooter.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 01/10/21.
//

import UIKit

final class DiscoverViewFooter: UICollectionReusableView {
    
    static let identifier = "Footer.DiscoverViewFooter"
    
    private weak var delegate: DiscoverViewFooterDelegate?
    
    private lazy var fetchButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(b)
        
        NSLayoutConstraint.activate([
            b.heightAnchor.constraint(equalToConstant: 44),
            b.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            b.centerXAnchor.constraint(equalTo: centerXAnchor),
            b.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        b.setTitle("Refresh books", for: .normal)
        b.isAccessibilityElement = true
        b.accessibilityTraits = .button
        b.accessibilityLabel = "Refresh books"
        b.accessibilityHint = "Double tap this to replace the books"
        
        b.backgroundColor = .accent
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 12
        
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(delegate: DiscoverViewFooterDelegate?) {
        guard self.delegate == nil else {
            return
        }
        self.delegate = delegate
        fetchButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc
    private func buttonAction() {
        delegate?.refreshList()
    }
    
}

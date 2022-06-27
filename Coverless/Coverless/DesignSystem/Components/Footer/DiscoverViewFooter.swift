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
            b.topAnchor.constraint(equalTo: topAnchor)
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
    
    private lazy var apiLabel: UILabel = {
        let l = UILabel()
        
        l.translatesAutoresizingMaskIntoConstraints = false
        addSubview(l)
        
        NSLayoutConstraint.activate([
            l.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: \.smallPositive),
            l.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: \.smallPositive),
            l.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: \.smallNegative),
            l.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        l.font = .systemFont(ofSize: 12, weight: .light)
        l.textColor = .secondaryLabel
        return l
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
        apiLabel.text = "Data provided by the Google Books"
    }
    
    @objc
    private func buttonAction() {
        delegate?.refreshList()
    }
    
}

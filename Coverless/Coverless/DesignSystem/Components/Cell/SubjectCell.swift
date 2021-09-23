//
//  SubjectCell.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 22/09/21.
//

import UIKit
import Combine

final class SubjectCell: UICollectionViewCell, Designable {
    
    static var identifier = "SubjectCell"
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "subject"
        return label
    }()
    
    private(set) var subject: String?
    
    override init(frame: CGRect) {
        subject = nil
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        stylize(with: DefaultDesignSystem())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subject = nil
    }
    
    private func setupHierarchy() {
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: \.mediumPositive),
            descriptionLabel.constraint(equalTo: contentView.leadingAnchor, constant: \.xLargePositive),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: \.xLargeNegative),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: \.mediumNegative)
        ])
    }
    
    func didSelectCell(with designSystem: DesignSystem = DefaultDesignSystem()) {
        contentView.backgroundColor = designSystem.palette.accent
        descriptionLabel.textColor = .white
    }
    
    func didDeselectCell(with designSystem: DesignSystem = DefaultDesignSystem()) {
        contentView.backgroundColor = designSystem.palette.backgroundCell
        descriptionLabel.textColor = designSystem.palette.accent

    }
    
    
    func setup(with subject: String) {
        self.subject = subject
        descriptionLabel.text = subject
        accessibilityLabel = subject
    }
    
    func stylize(with designSystem: DesignSystem) {
        descriptionLabel.stylize(with: designSystem.text.button)
        contentView.backgroundColor = designSystem.palette.backgroundCell
        accessibilityTraits = .button
        contentView.layer.cornerRadius = 18
        descriptionLabel.isUserInteractionEnabled = false
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        
        setupAccesibility()
    }
    
    private func setupAccesibility() {
        descriptionLabel.isAccessibilityElement = false
        isAccessibilityElement = true
        accessibilityTraits = .button
    }
}

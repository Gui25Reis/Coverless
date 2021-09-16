//
//  SynopsisCell.swift
//  Coverless
//
//  Created by Beatriz Duque on 15/09/21.
//

import UIKit

class SynopsisCell: UICollectionViewCell{
    private let synopsisLabel: UILabel
    private let infoButton: SynopsisCellButton
    private let discoverButton: SynopsisCellButton
    private lazy var normalLayout = [
        synopsisLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.70),
        synopsisLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: \.mediumPositive),
        synopsisLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: \.largePositive),
        synopsisLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: \.mediumNegative),
        synopsisLabel.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: \.smallNegative),
        infoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: \.mediumNegative),
        infoButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: \.mediumPositive),
        infoButton.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: \.mediumNegative),
        discoverButton.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: \.smallPositive),
        discoverButton.leadingAnchor.constraint(equalTo: infoButton.leadingAnchor),
        discoverButton.trailingAnchor.constraint(equalTo: infoButton.trailingAnchor),
        discoverButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: \.mediumNegative)
    ]
    
    private lazy var accessibilityLayout = [
        synopsisLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: \.mediumPositive),
        synopsisLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: \.largePositive),
        synopsisLabel.bottomAnchor.constraint(equalTo: infoButton.topAnchor, constant: \.xSmallPositive),
        synopsisLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: \.largeNegative),
        
        infoButton.leadingAnchor.constraint(equalTo: synopsisLabel.leadingAnchor),
        infoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        infoButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: \.smallNegative),
        
        discoverButton.topAnchor.constraint(equalTo: infoButton.topAnchor),
        discoverButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: \.smallPositive),
        discoverButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: \.largeNegative),
        discoverButton.bottomAnchor.constraint(equalTo: infoButton.bottomAnchor),
        
        contentView.heightAnchor.constraint(equalTo: synopsisLabel.heightAnchor, multiplier: 1.3)
    ]
    
    override init(frame: CGRect) {
        synopsisLabel = UILabel()
        infoButton = SynopsisCellButton(text: "Saiba mais", systemName: "info.circle")
        discoverButton = SynopsisCellButton(text: "Descubra", systemName: "plus")
        
        super.init(frame: frame)
        contentView.addSubview(synopsisLabel)
        contentView.addSubview(infoButton)
        contentView.addSubview(discoverButton)
        setupLayout()
        
        infoButton.action = { print("info") }
        discoverButton.action = { print("discover") }
    }
    
    func setupLayout(){
        
        ///label
        synopsisLabel.text = "Harry Potter é um garoto órfão que vive infeliz com seus tios, os Dursleys. Ele recebe uma carta contendo um convite para ingressar em Hogwarts, uma famosa escola especializada em formar jovens…"
        synopsisLabel.numberOfLines = 0
        synopsisLabel.lineBreakMode = .byTruncatingHead
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        synopsisLabel.stylize(with: BodyTextStyle())
                
        /* MARK: - Constraints da Label de sinopse */
        synopsisLabel.translatesAutoresizingMaskIntoConstraints = false
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        discoverButton.translatesAutoresizingMaskIntoConstraints = false
                
        //NSLayoutConstraint.activate()
        activateConstraints()
    }
    
    func activateConstraints(){
        if (traitCollection.preferredContentSizeCategory
                < .accessibilityMedium) { // Default font sizes
            accessibilityLayout.forEach{
                $0.isActive = false
            }
            NSLayoutConstraint.activate(normalLayout)
            
        } else { // Accessibility font sizes
            normalLayout.forEach{
                $0.isActive = false
            }
            NSLayoutConstraint.activate(accessibilityLayout)
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        activateConstraints()
    }
}

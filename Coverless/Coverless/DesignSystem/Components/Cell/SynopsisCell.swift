//
//  SynopsisCell.swift
//  Coverless
//
//  Created by Beatriz Duque on 15/09/21.
//

import UIKit

class SynopsisCell: UICollectionViewCell{
    private let synopsisLabel: UILabel
    private let infoButton: UIButton
    private let discoverButton: UIButton
    private lazy var normalLayout = [
        synopsisLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
        synopsisLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
        synopsisLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        synopsisLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        synopsisLabel.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor),
        infoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        infoButton.topAnchor.constraint(equalTo: contentView.topAnchor),
        infoButton.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
        discoverButton.topAnchor.constraint(equalTo: contentView.centerYAnchor),
        discoverButton.leadingAnchor.constraint(equalTo: infoButton.leadingAnchor),
        discoverButton.trailingAnchor.constraint(equalTo: infoButton.trailingAnchor),
        discoverButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ]
    
    private lazy var accessibilityLayout = [
        synopsisLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
        synopsisLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        synopsisLabel.bottomAnchor.constraint(equalTo: infoButton.topAnchor),
        synopsisLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        
        infoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        infoButton.bottomAnchor.constraint(equalTo: discoverButton.topAnchor),
        infoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        
        discoverButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        discoverButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        discoverButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        infoButton.heightAnchor.constraint(equalToConstant: 170),
        discoverButton.heightAnchor.constraint(equalToConstant: 170)
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
    }
    
    func setupLayout(){
        
        ///label
        synopsisLabel.text = "Harry Potter é um garoto órfão que vive infeliz com seus tios, os Dursleys. Ele recebe uma carta contendo um convite para ingressar em Hogwarts, uma famosa escola especializada em formar jovens…"
        synopsisLabel.backgroundColor = .systemPink
        synopsisLabel.numberOfLines = 0
        synopsisLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        contentView.backgroundColor = .systemBackground
        infoButton.backgroundColor = .blue
        discoverButton.backgroundColor = .orange
        
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

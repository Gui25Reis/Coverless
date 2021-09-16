//
//  SynopisisCell.swift
//  Coverless
//
//  Created by Beatriz Duque on 15/09/21.
//

import UIKit

final class DeprecatedSynopsisCell: UICollectionViewCell{
    let synopsisLabel: UILabel
    let contentStack: UIStackView
    let cellButtonStack: UIStackView
    let infoButton: UIButton
    let discoverButton: UIButton
    
    override init(frame: CGRect) {
        synopsisLabel = UILabel()
        contentStack = UIStackView()
        cellButtonStack = UIStackView()
        infoButton = SynopsisCellButton(text: "Saiba mais", systemName: "info.circle")
        discoverButton = SynopsisCellButton(text: "Descubra", systemName: "plus")
        
        super.init(frame: frame)
        
        contentView.addSubview(contentStack)
        setupLayout()
    }
    
    func setupLayout(){
        synopsisLabel.backgroundColor = .systemPink
        cellButtonStack.backgroundColor = .blue
        synopsisLabel.numberOfLines = 0
        synopsisLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        contentView.backgroundColor = .systemBackground
        synopsisLabel.stylize(with: BodyTextStyle())
        
        
        /* MARK: - Constraints da Stack (label + pilhas de botoes) */
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor,constant: \.smallPositive),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: \.smallNegative),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: \.smallNegative),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor,constant: \.smallPositive),
        ])
        
        ///Adicionando os conteudos nas pilhas
        addContent()
        
        /* MARK: - Constraints da Label de sinopse */
        synopsisLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            synopsisLabel.widthAnchor.constraint(equalTo: contentStack.widthAnchor, multiplier: 0.75)
        ])
        
        ///alinhamento das pilhas
        setupStackViewsLayout()
    }
    
    func addContent(){
        ///sinopse + pilha de botoes sendo adicionados na subview
        contentStack.addArrangedSubview(synopsisLabel)
        contentStack.addArrangedSubview(cellButtonStack)
        
        ///botoes
        cellButtonStack.addArrangedSubview(infoButton)
        cellButtonStack.addArrangedSubview(discoverButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupStackViewsLayout()
    }
    
    /* MARK: - Ajuste de alinhamento das pilhas */
    func setupStackViewsLayout(){
        if (traitCollection.preferredContentSizeCategory
                < .accessibilityMedium) { // Default font sizes
            
            ///alinhamento da pilha principal (sinopse + pilha de botoes)
            contentStack.alignment = .fill
            contentStack.axis = .horizontal
            contentStack.spacing = 8
            contentStack.distribution = .fill
            
            ///alinhando a pilha dos botoes
            cellButtonStack.alignment = .fill
            cellButtonStack.axis = .vertical
            cellButtonStack.spacing = 4
            cellButtonStack.distribution = .fillProportionally
            
        } else { // Accessibility font sizes
            
            contentStack.alignment = .fill
            contentStack.axis = .vertical
            contentStack.spacing = 8
            contentStack.distribution = .fill
            
            cellButtonStack.alignment = .fill
            cellButtonStack.axis = .horizontal
            cellButtonStack.spacing = 4
            cellButtonStack.distribution = .fillProportionally
            
        }
    }
}

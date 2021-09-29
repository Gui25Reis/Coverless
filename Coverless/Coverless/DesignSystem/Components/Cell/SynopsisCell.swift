//
//  SynopsisCell.swift
//  Coverless
//
//  Created by Beatriz Duque on 15/09/21.
//


import UIKit

class SynopsisCell: UICollectionViewCell, Designable{
    private let synopsisLabel: UILabel
    private let infoButton: SynopsisCellButton
    private let discoverButton: SynopsisCellButton
    
    private weak var delegate: SynopsisCellDelegate? = nil
    private var book: Book? = nil
    
    static let identifier: String = "SynopsisCell"
    
    private lazy var normalLayout = [
        synopsisLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.70),
        synopsisLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: \.mediumPositive),
        synopsisLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: \.largePositive),
        synopsisLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: \.mediumNegative),
        synopsisLabel.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: \.smallNegative),
        infoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: \.mediumNegative),
        infoButton.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: \.xSmallNegative),
        infoButton.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2, constant: -20),
        discoverButton.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2, constant: -20),
        discoverButton.leadingAnchor.constraint(equalTo: infoButton.leadingAnchor),
        discoverButton.trailingAnchor.constraint(equalTo: infoButton.trailingAnchor),
        discoverButton.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: \.xSmallPositive),
        contentView.heightAnchor.constraint(greaterThanOrEqualTo: contentView.widthAnchor, multiplier: 0.4)
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
        infoButton = SynopsisCellButton(text: "More Info", systemName: "info.circle")
        discoverButton = SynopsisCellButton(text: "Discover", systemName: "plus")
        
        super.init(frame: frame)
        contentView.addSubview(synopsisLabel)
        contentView.addSubview(infoButton)
        contentView.addSubview(discoverButton)
        setupLayout()
        setupActions()
        setupAccessibility()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        book = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
    }
    
    private func setupShadow() {
        layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        layer.shadowOffset = CGSize(width: 2, height: 2.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.1
    }
    
    private func setupLayout(){
        /* MARK: - Constraints da Label de sinopse */
        synopsisLabel.translatesAutoresizingMaskIntoConstraints = false
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        discoverButton.translatesAutoresizingMaskIntoConstraints = false
                
        activateConstraints()
    }
    
    private func activateConstraints(){
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
    
    private func setupActions() {
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        discoverButton.addTarget(self, action: #selector(discoverBook), for: .touchUpInside)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        activateConstraints()
    }
    
    //MARK: Adicionar estrutura de dados
    func setup(book: Book, delegate: SynopsisCellDelegate?) {
        self.book = book
        synopsisLabel.text = book.description
        synopsisLabel.accessibilityLabel = "Card de sinopse:\(book.description)"
        stylize(with: DefaultDesignSystem.shared)
        self.delegate = delegate
    }
    
    @objc
    private func showInfo() {
        guard
            let delegate = delegate,
            let book = book
        else { return }
        delegate.showInfo(for: book)
    }
    
    @objc
    private func discoverBook() {
        guard
            let delegate = delegate,
            let book = book
        else { return }
        delegate.discoverBook(book)
    }
    
    //MARK: Stylize + VoiceOver
    func stylize(with designSystem: DesignSystem) {
        backgroundColor = designSystem.palette.backgroundCell
        layer.cornerRadius = 12
        synopsisLabel.stylize(with: designSystem.text.body)
    }
    
    func setupAccessibility() {
        synopsisLabel.isAccessibilityElement = true
        synopsisLabel.accessibilityLabel = "Synopsis Card:\(synopsisLabel.text ?? "")"
        infoButton.isAccessibilityElement = true
        infoButton.accessibilityLabel = "More Info"
        
        discoverButton.isAccessibilityElement = true
        discoverButton.accessibilityLabel = "Discover"
        discoverButton.accessibilityHint = "Add to shelf"
        
        self.accessibilityElements = [synopsisLabel, infoButton, discoverButton]
        
        
    }
}

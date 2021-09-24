//
//  ShelfCell.swift
//  Coverless
//
//  Created by Beatriz Duque on 17/09/21.
//

import UIKit

//vetor provisorio
let colors: [UIColor] = [.accent,.textPrimary,.titlePrimary,.backgroundPrimary]

class ShelfCell: UICollectionViewCell, Designable{

    private weak var delegate: ShelfCellDelegate? = nil

    
    private let bookTitle: UILabel
    private let bookStatus: StatusButton
    private let favButton: UIButton
    private let imgView: ImageBook
    private var stars: StarsRating
    
    /* MARK: - Constraints da normais e de acessibilidade */
    private lazy var normalLayout = [
        imgView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.30),
        imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: \.mediumPositive),
        imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: \.largePositive),
        imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: \.mediumNegative),
        imgView.trailingAnchor.constraint(equalTo: bookTitle.leadingAnchor, constant: \.smallNegative),
        
        favButton.topAnchor.constraint(equalTo: imgView.topAnchor,constant: \.smallNegative),
        favButton.leadingAnchor.constraint(equalTo: imgView.leadingAnchor,constant: \.smallNegative),
        favButton.widthAnchor.constraint(equalToConstant: 36),
        favButton.heightAnchor.constraint(equalToConstant: 36),
        
        bookTitle.trailingAnchor.constraint(equalTo:contentView.trailingAnchor,constant: \.smallNegative),
        bookTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: \.largePositive),
        bookTitle.bottomAnchor.constraint(equalTo: bookStatus.topAnchor, constant: \.mediumNegative),
        
        bookStatus.leadingAnchor.constraint(equalTo: imgView.trailingAnchor,constant: \.smallPositive),
        bookStatus.bottomAnchor.constraint(equalTo: stars.topAnchor, constant: \.mediumNegative),
        bookStatus.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
        
        stars.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: \.largeNegative),
        stars.leadingAnchor.constraint(equalTo: imgView.trailingAnchor,constant: \.smallPositive)

    ]
    
    private lazy var accessibilityLayout = [
        imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: \.mediumPositive),
        imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: \.smallPositive),
        imgView.bottomAnchor.constraint(equalTo: bookTitle.topAnchor,constant: \.mediumNegative),
        imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: \.smallNegative),
    
        bookTitle.trailingAnchor.constraint(equalTo:contentView.trailingAnchor,constant: \.smallNegative),
        bookTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: \.smallPositive),
        bookTitle.bottomAnchor.constraint(equalTo: bookStatus.topAnchor,constant: \.mediumNegative),


        bookStatus.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: \.smallPositive),
        bookStatus.trailingAnchor.constraint(equalTo:contentView.trailingAnchor,constant: \.mediumNegative),
        bookStatus.bottomAnchor.constraint(equalTo: stars.topAnchor, constant: \.mediumNegative),
        
        stars.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: \.largeNegative),
        stars.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: \.smallPositive),
        
        imgView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6)
    ]
    
    //private lazy var accessibilityLayout = []
    
    override init(frame: CGRect) {
        bookTitle = UILabel()
        bookStatus = StatusButton()
        favButton = UIButton()
        imgView = ImageBook()
        stars = StarsRating()
        
        super.init(frame: frame)
        contentView.addSubview(imgView)
        contentView.addSubview(bookTitle)
        contentView.addSubview(bookStatus)
        contentView.addSubview(favButton)
        contentView.addSubview(stars)
        setupLayout()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /* MARK: - Configuração do Layout */

    private func setupLayout(){
        
        imgView.translatesAutoresizingMaskIntoConstraints = false
        bookTitle.translatesAutoresizingMaskIntoConstraints = false
        bookStatus.translatesAutoresizingMaskIntoConstraints = false
        favButton.translatesAutoresizingMaskIntoConstraints = false
        stars.translatesAutoresizingMaskIntoConstraints = false

        imgView.backgroundColor = colors[Int.random(in: 0..<colors.count)]
        NSLayoutConstraint.activate(normalLayout)
        activateConstraints()
    }
    
    /* MARK: - Ativando/desativando constraints de acessibilidade */

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
    
    ///funcao que ativar/desativas as constraints normais ou de acessibilidade
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        activateConstraints()
    }
    
    func stylize(with designSystem: DesignSystem) {
        
        //view principal
        backgroundColor = designSystem.palette.backgroundCell
        layer.cornerRadius = 12
        
        //elementos
        bookTitle.stylize(with: designSystem.text.title)
        bookTitle.numberOfLines = 0
        
        //favButton
        //testando o botao de fav
        favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favButton.tintColor = designSystem.palette.accent
        favButton.backgroundColor = designSystem.palette.backgroundCell
        favButton.layer.cornerRadius = 18

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
    }
    
    /* MARK: - Setup da celula */
    ///funcao acessada pela celula na collection
    //autalizar para func setup(book: MyBook){}
    func setup(title: String,status: BookStatus, rating: Int,delegate: ShelfCellDelegate?){
        stylize(with: DefaultDesignSystem.shared)
        ///botao de status
        bookStatus.setStatus(status:status)
        ///titulo do livro
        bookTitle.text = title
        ///rating do livro
        stars.setRating(rating: rating)
        
        self.delegate = delegate
        
        setAccessibility()
    }
    
    
    func setAccessibility(){
        favButton.isAccessibilityElement = true
        favButton.accessibilityHint = "To favorite"
        favButton.accessibilityLabel = "Heart symbol"
        
        bookTitle.isAccessibilityElement = true
        
        bookStatus.isAccessibilityElement = true
        bookStatus.accessibilityHint = "Book status"
        bookStatus.accessibilityTraits = .none
    
        stars.isAccessibilityElement = true
        stars.accessibilityHint = "Book review"
        stars.accessibilityLabel = "Rating:\(stars.getRating()) stars out of five"
        
        self.accessibilityElements = [bookTitle,bookStatus, stars,favButton]

    
    }
}

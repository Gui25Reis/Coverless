//
//  StarsRating.swift
//  Coverless
//
//  Created by Beatriz Duque on 20/09/21.
//

import UIKit

class StarsRating: UIView{
    private let star1 = UIImageView(frame: .zero)
    private let star2 = UIImageView(frame: .zero)
    private let star3 = UIImageView(frame: .zero)
    private let star4 = UIImageView(frame: .zero)
    private let star5 = UIImageView(frame: .zero)
    public var rating: Int
    public lazy var vetStars: [UIImageView] = [star1,star2,star3,star4,star5]


    
    init() {
        self.rating = 0 //inicializa com 0 para colocar as estrelas na tela todas inicialmente vazias
        super.init(frame: .zero)
        let symbol = UIImage(systemName: "star")

        for i in 0..<vetStars.count{
            if let symbol = symbol {
                vetStars[i].contentMode = .scaleAspectFit
                vetStars[i].image = symbol
                    .applyingSymbolConfiguration(symbol.getSymbolConfiguration(for: traitCollection))
            }
            vetStars[i].translatesAutoresizingMaskIntoConstraints = false
            vetStars[i].isUserInteractionEnabled = false
            vetStars[i].adjustsImageSizeForAccessibilityContentSizeCategory = true

            addSubview(vetStars[i])
        }
        
        NSLayoutConstraint.activate([
            star1.leadingAnchor.constraint(equalTo: leadingAnchor),
            star1.bottomAnchor.constraint(equalTo: bottomAnchor),
            star1.heightAnchor.constraint(equalTo: heightAnchor),
            
            star2.leadingAnchor.constraint(equalTo: star1.trailingAnchor,constant: 2),
            star2.bottomAnchor.constraint(equalTo: bottomAnchor),
            star1.heightAnchor.constraint(equalTo: heightAnchor),
            
            star3.leadingAnchor.constraint(equalTo: star2.trailingAnchor,constant: 2),
            star3.bottomAnchor.constraint(equalTo: bottomAnchor),
            star3.heightAnchor.constraint(equalTo: heightAnchor),
            
            star4.leadingAnchor.constraint(equalTo: star3.trailingAnchor,constant: 2),
            star4.bottomAnchor.constraint(equalTo: bottomAnchor),
            star4.heightAnchor.constraint(equalTo: heightAnchor),
            
            star5.leadingAnchor.constraint(equalTo: star4.trailingAnchor,constant: 2),
            star5.trailingAnchor.constraint(equalTo: trailingAnchor),
            star5.bottomAnchor.constraint(equalTo: bottomAnchor),
            star5.heightAnchor.constraint(equalTo: heightAnchor),

        ])
        
        setAccessibility()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* MARK: - Funcoes que envolvem o rating das estrlas */
    public func setRating(rating: Int){
        self.rating = rating
        styleWithRating(vet: vetStars)
    }
    public func getRating()->Int{
        return self.rating
    }
    ///funcao que preenche a estrela de acordo com a review do livro que eh passada pela API
    private func styleWithRating(vet: [UIImageView]){
        for i in 0..<rating{
            let symbol = UIImage(systemName: "star.fill")
            if let symbol = symbol {
                vet[i].contentMode = .scaleAspectFit
                vet[i].image = symbol
                        .applyingSymbolConfiguration(symbol.getSymbolConfiguration(for: traitCollection))
            }
        }
    }
    func setAccessibility(){
        self.isAccessibilityElement = true
        star1.isAccessibilityElement = false
        star2.isAccessibilityElement = false
        star3.isAccessibilityElement = false
        star4.isAccessibilityElement = false
        star5.isAccessibilityElement = false
    }
}

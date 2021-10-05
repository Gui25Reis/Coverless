//
//  BookView.swift
//  Coverless
//
//  Created by Beatriz Duque on 22/09/21.
//

import UIKit

final class BookView: UIView, Designable {
    
    let designSystem: DesignSystem
    var currentStatus: BookStatus
    private var book: MyBook
    private var shopLink: String

    //MARK: Views
    private lazy var imgBook: UIView = {
        let img = ImageBook(image: UIImage(named: "ImageBookDefault")!)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
        
    }()
    private lazy var synopsisField: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.stylize(with: designSystem.text.body)
        tv.adjustsFontForContentSizeCategory = true
        tv.text = "Harry Potter é um garoto órfão que vive infeliz com seus tios, os Dursleys. Ele recebe uma carta contendo um convite para ingressar em Hogwarts, uma famosa escola especializada em formar jovens… Harry Potter é um garoto órfão que vive infeliz com seus tios, os Dursleys. Ele recebe uma carta contendo um convite para ingressar em Hogwarts, uma famosa escola especializada em formar jovens…"
        let padding = -tv.textContainer.lineFragmentPadding
        tv.contentInset = .init(top: padding, left: padding, bottom: 0, right: padding)
        
        return tv
    }()
    
    private lazy var ratingHeader: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.stylize(with: designSystem.text.header)
        l.numberOfLines = 0
        l.text = "Rating"
        return l
    }()
    
    private lazy var statusHeader: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.stylize(with: designSystem.text.header)
        l.numberOfLines = 0
        l.text = "Status"
        return l
    }()
    
    private lazy var shopHeader: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.stylize(with: designSystem.text.header)
        l.numberOfLines = 0
        l.text = "Shop links"
        return l
    }()
    
    private lazy var statusButtonRead: StatusButton = {
        let b = StatusButton()
        b.setStatus(status: .read)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private lazy var statusButtonReading: StatusButton = {
        let b = StatusButton()
        b.setStatus(status: .reading)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private lazy var statusButtonWant: StatusButton = {
        let b = StatusButton()
        b.setStatus(status: .want)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private lazy var ratingStars: StarsRating = {
        let stars = StarsRating()
        stars.translatesAutoresizingMaskIntoConstraints = false
        stars.setRating(rating: 4)
        return stars
    }()
    
    private lazy var shopView: ShopView = {
        let shopView = ShopView(image: UIImage(named: "GoogleBooksLogo")!, titulo: "Amazon Prime", price: "XX,00"/*"R$\(price)"*/,url: "")
        shopView.translatesAutoresizingMaskIntoConstraints = false
        return shopView
    }()
    
    
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
        stv.spacing = designSystem.spacing.mediumPositive
        return stv
    }()
    private lazy var stackViewButtons: UIStackView = {
        let stv = UIStackView()
        stv.axis = .horizontal
        stv.translatesAutoresizingMaskIntoConstraints = false
        stv.distribution = .fillEqually
        stv.spacing = designSystem.spacing.smallPositive
        return stv
    }()
    
    
    private let tabBarHeight: CGFloat
    
    //MARK: Init
    
    init(book: MyBook, designSystem: DesignSystem = DefaultDesignSystem.shared, tabBarHeight: CGFloat = 49) {
        self.book = book
        self.designSystem = designSystem
        self.tabBarHeight = tabBarHeight
        self.shopLink = "..."
        currentStatus = .reading
        super.init(frame: .zero)
        checkCurrentStatus()
        setupHierarchy()
        setupLayout()
        setupActions()
        stylize(with: designSystem)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    
    private func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imgBook)
        ///sinopse
        stackView.addArrangedSubview(synopsisField)
        ///rating
        ///as linhas abaixo estao comentadas pois nao vamos uitilizar o rating por enquanto
        //stackView.addArrangedSubview(ratingHeader)
        //stackView.addArrangedSubview(ratingStars)
        ///botoes de status
        stackView.addArrangedSubview(statusHeader)
        stackView.addArrangedSubview(stackViewButtons)
        stackViewButtons.addArrangedSubview(statusButtonWant)
        stackViewButtons.addArrangedSubview(statusButtonReading)
        stackViewButtons.addArrangedSubview(statusButtonRead)
        
        
        ///shop
        if book.shopLink != ""{
            stackView.addArrangedSubview(shopHeader)
            stackView.addArrangedSubview(shopView)
        }
        

    }
    
    private func setupLayout() {
        setupScrollViewConstraints()
        setupScrollViewContentConstraints()
        activateConstraints()
    }
    
    private func setupScrollViewConstraints() {
        //scrollView.strechToBounds(of: layoutMarginsGuide)
        let constraints: [NSLayoutConstraint] = [
            scrollView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: \.smallPositive),
            scrollView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: \.mediumNegative)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupScrollViewContentConstraints() {
        contentView.strechToBounds(of: scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.strechToBounds(of: contentView)
    }
    
    //MARK: Core data

    //atualizar para setupContent(book: MyBook)
    public func setupContentBook() {
        ///status de leitura
        currentStatus = BookStatus(rawValue: Int(book.status)) ?? .reading
        checkCurrentStatus()
        ///link
        shopView.shopTitle.text = "Google Books™"
        shopView.priceValue.isHidden = true //escondendo informacao que nao conseguimos coletar
        shopLink = book.shopLink ?? ""
        shopView.url = book.shopLink ?? "https://google.com"
        ///rating?
        ratingStars.setRating(rating: Int(book.rating))
        ///sinopse
        synopsisField.text = book.synopsis

    }
    
    //MARK: Bindings and actions

    private func setupActions() {
        statusButtonRead.addTarget(self, action: #selector(setStatusRead), for: .touchUpInside)
        statusButtonReading.addTarget(self, action: #selector(setStatusReading), for: .touchUpInside)
        statusButtonWant.addTarget(self, action: #selector(setStatusWant), for: .touchUpInside)
    }
    
    func setupButtonRead(_ action: @escaping () -> Void) {
        let readAction: UIAction = UIAction { _ in action() }
        statusButtonRead.addAction(readAction, for: .touchUpInside)
    }
    func setupButtonReading(_ action: @escaping () -> Void) {
        let readingAction: UIAction = UIAction { _ in action() }
        statusButtonReading.addAction(readingAction, for: .touchUpInside)
    }
    func setupButtonAbandoned(_ action: @escaping () -> Void) {
        let wantAction: UIAction = UIAction { _ in action() }
        statusButtonWant.addAction(wantAction, for: .touchUpInside)
    }
    
    //MARK: Buttons Functions
    
    @objc
    private func setStatusRead() {
        currentStatus = .read
        checkCurrentStatus()

    }
    
    @objc
    private func setStatusReading(){
        currentStatus = .reading
        checkCurrentStatus()
    }
    
    @objc
    private func setStatusWant(){
        currentStatus = .want
        checkCurrentStatus()
    }
    
    ///funcao utilizada para representacao visual dos botoes
    private func checkCurrentStatus(){
        if currentStatus == .read{
            statusButtonRead.setState(isActive: true)
            statusButtonReading.setState(isActive: false)
            statusButtonWant.setState(isActive: false)
        }
        else if currentStatus == .reading{
            statusButtonRead.setState(isActive: false)
            statusButtonReading.setState(isActive: true)
            statusButtonWant.setState(isActive: false)
        }
        else{
            statusButtonRead.setState(isActive: false)
            statusButtonReading.setState(isActive: false)
            statusButtonWant.setState(isActive: true)
        }
        statusButtonRead.setStatus(status: .read)
        statusButtonReading.setStatus(status: .reading)
        statusButtonWant.setStatus(status: .want)
    }
    
    //MARK: Designable Protocol

    func stylize(with designSystem: DesignSystem) {
        backgroundColor = designSystem.palette.backgroundPrimary
        setAccessibility()
    }
    
    
    func setAccessibility(){
        scrollView.isAccessibilityElement = true
        
        synopsisField.isAccessibilityElement = true
        
        ratingStars.isAccessibilityElement = true
        ratingStars.accessibilityHint = "Book review"
        ratingStars.accessibilityLabel = "Rating:\(ratingStars.getRating()) stars out of five"
        
        statusHeader.isAccessibilityElement = true
        statusHeader.accessibilityLabel = "Actual status is \(currentStatus)"
        statusHeader.accessibilityHint = "Set book status"
        
        statusButtonRead.isAccessibilityElement = true
        statusButtonRead.accessibilityTraits = .button
        
        statusButtonReading.isAccessibilityElement = true
        statusButtonReading.accessibilityTraits = .button
        
        statusButtonWant.isAccessibilityElement = true
        statusButtonWant.accessibilityTraits = .button
    
        shopHeader.isAccessibilityElement = true
        shopView.isAccessibilityElement = true
        shopView.accessibilityHint = "Options to shop"
        shopView.shopTitle.isAccessibilityElement = true
        shopView.shopTitle.accessibilityLabel = shopView.shopTitle.text
        shopView.priceValue.isAccessibilityElement = true
        shopView.priceValue.accessibilityLabel = shopView.priceValue.text
        shopView.shopButton.isAccessibilityElement = true
        shopView.shopButton.accessibilityHint = "click to be redirected"
        
        self.accessibilityElements = [synopsisField,ratingHeader, ratingStars,statusHeader,statusButtonRead,statusButtonReading,statusButtonWant,shopHeader,shopView, shopView.shopTitle,shopView.priceValue,shopView.shopButton]
        
    }
    
    //MARK: Accessibility on ScrollView
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       activateConstraints()
    }
    
    func activateConstraints(){
        if (traitCollection.preferredContentSizeCategory)
            < .accessibilityMedium{
            //stack view normal
            stackViewButtons.axis = .horizontal
            stackViewButtons.alignment = .center
            
        }else{
            //stack view para acessibilidade
            stackViewButtons.axis = .vertical
            stackViewButtons.alignment = .leading
        }
    }

    //MARK: Accessibility on ScrollView
    
//    override func accessibilityElementDidBecomeFocused() {
//        guard let sv = superview as? UIScrollView else {
//            return
//        }
//        sv.accessibilityScroll(.down)
//        UIAccessibility.post(notification: .layoutChanged, argument: nil)
//
//    }
    
}

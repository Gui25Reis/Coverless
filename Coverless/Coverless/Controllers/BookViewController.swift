import UIKit

class BookViewController: UIViewController {
    weak var coordinator: ShelfCoordinator?
    private var book: MyBook
    
    lazy var contentView: BookView = {
        BookView(book: book, designSystem: DefaultDesignSystem.shared, tabBarHeight: tabBarController?.tabBar.frame.height ?? 100)
    }()
    
    private lazy var shareButtonBar: UIBarButtonItem  = .init(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    
    init(book: MyBook){
        //recebe o livro que esta sendo acessado atraves da collection
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isAccessibilityElement = true
    }
    
    override func viewDidLoad() {
        //atualizar para contentView.setupContent(book: book)
        contentView.setupContentBook()
        contentView.setupButtonRead(setRead)
        contentView.setupButtonReading(setReading)
        contentView.setupButtonAbandoned(setAbandoned)
        
        navigationItem.rightBarButtonItem = shareButtonBar
        shareButtonBar.isAccessibilityElement = true
        shareButtonBar.accessibilityHint = "Click to share synopsis Book"
    

    }
    
    private func setRead(){
        book.status = 0
        DataBooks.shared.saveContext()

    }
    private func setReading(){
        book.status = 1
        DataBooks.shared.saveContext()

    }
    private func setAbandoned(){
        book.status = 2
        DataBooks.shared.saveContext()

    }
    
    @objc private func shareTapped(){
        let msgDefault = "Hey, look at this book I discovered through the Coverless app!"
        let shareVc = UIActivityViewController(activityItems: [msgDefault,book.title ?? "","Synopsis:(\(book.synopsis ?? "Unavailable")",book.shopLink ?? ""], applicationActivities: [])
        shareVc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
                present(shareVc, animated: true)
    }
}

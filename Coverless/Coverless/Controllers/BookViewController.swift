import UIKit

class BookViewController: UIViewController {
    weak var coordinator: ShelfCoordinator?
    private var book: MyBook
    
    lazy var contentView: BookView = {
        BookView(book:book, designSystem: DefaultDesignSystem.shared, tabBarHeight: tabBarController?.tabBar.frame.height ?? 100)
    }()
    
    
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

    }
    
    private func setRead(){
        book.status = 0
    }
    private func setReading(){
        book.status = 1
    }
    private func setAbandoned(){
        book.status = 2
    }
    
}

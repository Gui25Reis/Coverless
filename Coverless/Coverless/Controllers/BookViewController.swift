import UIKit

class BookViewController: UIViewController {
    weak var coordinator: ShelfCoordinator?
    //let book: MyBook
    
    lazy var contentView: BookView = {
        BookView(designSystem: DefaultDesignSystem.shared, tabBarHeight: tabBarController?.tabBar.frame.height ?? 100)
    }()
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        //atualizar para contentView.setupContent(book: book)
        contentView.setupContent()
        contentView.setupButtonRead(setRead)
        contentView.setupButtonReading(setReading)
        contentView.setupButtonAbandoned(setAbandoned)

    }
    
    private func setRead(){
        print("status Read")
    }
    private func setReading(){
        print("status Reading")
    }
    private func setAbandoned(){
        print("status Abandoned")
    }
}

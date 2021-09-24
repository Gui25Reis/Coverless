import UIKit

class BookViewController: UIViewController {
    weak var coordinator: ShelfCoordinator?
    
    lazy var contentView: BookView = {
        BookView(designSystem: DefaultDesignSystem.shared, tabBarHeight: tabBarController?.tabBar.frame.height ?? 100)
    }()
    
    let viewModel: MoreInfoViewModel
    
    init(viewModel: MoreInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        contentView.setupContent(synopsis: viewModel.synopsis, rating: viewModel.rating)
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

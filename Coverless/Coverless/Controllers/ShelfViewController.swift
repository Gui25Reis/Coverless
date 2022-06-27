//
//  ShelfViewController.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 16/09/21.
//

import UIKit
import CoreData

final class ShelfViewController: UIViewController, NSFetchedResultsControllerDelegate, ShelfCellDelegate{
    
    func turnFav() {
        ///atualizada o vetor que esta sendo carregado na collection
        switchSegmented()
        
        if segmentedControl.selectedSegmentIndex == 1 {
            cv.reloadData()
        }
    }
    
    private lazy var fetchResultController: NSFetchedResultsController<MyBook> = {
        let request: NSFetchRequest<MyBook> = MyBook.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MyBook.title, ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: DataBooks.shared.contenxt,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    weak var coordinator: ShelfCoordinator?
    private var books:[MyBook] = []
    private var filteredBooks: [MyBook] = []
    
    let designSystem: DesignSystem = DefaultDesignSystem()
    let cv: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: ShelfViewController.createCollectionViewLayout())
    
    let segmentedControl = UISegmentedControl(items: ["All discovered","Favorites"])
    
    /* MARK: - Ciclo de Vida */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cv.reloadData()
    }
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
        //let button = SynopsisCellButton(text: "Discover", systemName: "trash", designSystem: designSystem)
        view.backgroundColor = designSystem.palette.backgroundPrimary
        
        ///collection view
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear

        
        ///segmented control
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(indexChanged(_: )), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        view.addSubview(segmentedControl)
        view.addSubview(cv)
        
        ///configurando constraints
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: \.mediumNegative),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: \.mediumPositive),
            
            cv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cv.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,constant: \.mediumPositive),
            cv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cv.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        cv.register(ShelfCell.self, forCellWithReuseIdentifier: "cell")
        cv.isAccessibilityElement = false
        cv.shouldGroupAccessibilityChildren = true
        
        do {
            try fetchResultController.performFetch()
            self.books = fetchResultController.fetchedObjects ?? []
            switchSegmented()
        } catch {
            fatalError("fudeu brasil")
        }
    }
    
    
    
    /* MARK: - Configurações */
    
    // Coloque aqui as funções de consfigurações em geral
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let books = controller.fetchedObjects as? [MyBook] else { return }
        self.books = books
        self.switchSegmented()
    }
    
    
    /* MARK: - Ações dos botões */
    
    // Coloque aqui as açòes dos botões da view
    static private func createCollectionViewLayout() -> UICollectionViewLayout {
        // Define Item Size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500.0))

        // Create Item
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        

        // Define Group Size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500.0))

        // Create Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [ item ])
        
        group.edgeSpacing = .init(leading: .fixed(0), top: .fixed(4), trailing: .fixed(0), bottom: .fixed(4))
        // Create Section
        let section = NSCollectionLayoutSection(group: group)

        // Configure Section
        section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0)

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switchSegmented()
        cv.reloadData()
    }
    
    
    func switchSegmented(){
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            filteredBooks = books
        case 1:
            filteredBooks = books.filter { $0.isFavorite == true }
        default:
            break
        }
    }
    
    
    func setAccessibility(){
        segmentedControl.isAccessibilityElement = true
        segmentedControl.accessibilityHint = "Select your preferences"
    }
    
}

/* MARK: - Collection View */

extension ShelfViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.showBook(book: filteredBooks[indexPath.row])
    }
}

extension ShelfViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if books.isEmpty {
            setEmptyMessage(message: "No books discovered on the shelf. Let's discover a new one?") //ALL emptyState
            segmentedControl.isHidden = true
      
        } else {
            restore() //collectionview com dados do coreData
            segmentedControl.isHidden = false
        }
        return self.filteredBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ShelfCell
        else {
            preconditionFailure("Cell Register not configured correctly")
        }
        cell.setup(book: filteredBooks[indexPath.row])
        cell.setFavorite(status: filteredBooks[indexPath.row].isFavorite)
        cell.delegate = self
        return cell
    }
    
    func setEmptyMessage(message: String) {
        let empty = EmptyView(message: message)
        cv.backgroundView = empty
        empty.delegate = self
    }
    
    func restore() {
        cv.backgroundView = nil
    }
}

/* MARK: - Extensions */

extension ShelfViewController: EmptyViewDelegate {
    func toDiscover() {
        tabBarController!.selectedIndex = 0
    }
    
}


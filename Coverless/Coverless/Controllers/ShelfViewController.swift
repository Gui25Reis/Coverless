//
//  ShelfViewController.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 16/09/21.
//

import UIKit

final class ShelfViewController: UIViewController, ShelfCellDelegate {
    
    weak var coordinator: ShelfCoordinator?
    
    
    let designSystem: DesignSystem = DefaultDesignSystem()
    let cv: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: ShelfViewController.createCollectionViewLayout())
    
    let segmentedControl = UISegmentedControl(items: ["Favorites","Discovered"])
    
    /* MARK: - Ciclo de Vida */
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
        //let button = SynopsisCellButton(text: "Descubra", systemName: "trash", designSystem: designSystem)
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
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
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
        
        
    }
    
    
    
    /* MARK: - Configurações */
    
    // Coloque aqui as funções de consfigurações em geral
    
    
    
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
    
    func turnFav() {
        //
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
            switch segmentedControl.selectedSegmentIndex
            {
            case 0:
                print("favorito selecionado")
            case 1:
                print("descobertas selecionado")
            default:
                break;
            }
    }
    
    func setAccessibility(){
        segmentedControl.isAccessibilityElement = true
        segmentedControl.accessibilityHint = "Select your preferences"
    }
    
}
extension ShelfViewController:UICollectionViewDelegate{
    
}

extension ShelfViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ShelfCell
        else {
            preconditionFailure("Cell Register not configured correctily")
        }
        cell.setup(title:"Harry Potter e a Câmara Secreta",status: .abandoned ,rating: 3,delegate: self)
        return cell
    }
    
    
}


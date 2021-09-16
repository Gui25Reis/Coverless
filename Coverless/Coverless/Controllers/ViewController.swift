//
//  ViewController.swift
//  Coverless
//
//  Created by Gui Reis on 14/09/21.
//

import UIKit

class MenuViewController: UIViewController {
    
    let designSystem: DesignSystem = DefaultDesignSystem()
    let cv: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: MenuViewController.createCollectionViewLayout())
    
    /* MARK: - Ciclo de Vida */
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
        //let button = SynopsisCellButton(text: "Descubra", systemName: "trash", designSystem: designSystem)
        view.backgroundColor = designSystem.palette.backgroundPrimary
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        view.addSubview(cv)
        
        NSLayoutConstraint.activate([
            cv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cv.topAnchor.constraint(equalTo: view.topAnchor),
            cv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cv.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        cv.register(SynopsisCell.self, forCellWithReuseIdentifier: "cell")
        
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
}
extension MenuViewController:UICollectionViewDelegate{
    
}

extension MenuViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SynopsisCell else {
            preconditionFailure("Cell Register not configured correctily")
        }
        cell.setup(synopsis: "Harry Potter é um garoto órfão que vive infeliz com seus tios, os Dursleys. Ele recebe uma carta contendo um convite para ingressar em Hogwarts, uma famosa escola especializada em formar jovens…", delegate: self)
        return cell
    }
    
    
}

extension MenuViewController: SynopsisCellDelegate {
    func showInfo() {
        print("info pressed")
    }
    
    func discoverBook() {
        print("discorver pressed")
    }
    
    
}

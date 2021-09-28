//
//  DiscoverCollectionViewDataSource.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 22/09/21.
//

import UIKit

class DiscoverCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    weak var cellDelegate: SynopsisCellDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SynopsisCell.identifier, for: indexPath) as? SynopsisCell else {
            preconditionFailure("Cell Register not configured correctily")
        }
        cell.setup(synopsis: "Harry Potter é um garoto órfão que vive infeliz com seus tios, os Dursleys. Ele recebe uma carta contendo um convite para ingressar em Hogwarts, uma famosa escola especializada em formar jovens…", delegate: cellDelegate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                         withReuseIdentifier: SubjectCollectionHeader.identifier,
                                                                         for: indexPath) as? SubjectCollectionHeader
        else {
            preconditionFailure("Header View configured wrong")
        }
        
        return header
    }
    
}

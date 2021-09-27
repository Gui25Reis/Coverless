//
//  DiscoverCollectionViewDataSource.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 22/09/21.
//

import UIKit

class DiscoverCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    weak var cellDelegate: SynopsisCellDelegate?
    private let subjects: [Subject] = PropertyListDecoder.decode("Subjects", to: [Subject].self) ?? []
    private var selectedSubject: Subject? = nil
    
    func selectSubject(for indexPath: IndexPath) {
        guard
            indexPath.section == 0,
            indexPath.row < subjects.count
        else {
            preconditionFailure("invalid index path")
        }
        selectedSubject = subjects[indexPath.row]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 2 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return subjects.count
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubjectCell.identifier, for: indexPath) as? SubjectCell
            else {
                preconditionFailure("Cell Register not configured correctily")
            }
            
            let isSelected = (selectedSubject == subjects[indexPath.row])
            cell.setup(with: subjects[indexPath.row].name, isSelected: isSelected)
            
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SynopsisCell.identifier, for: indexPath) as? SynopsisCell else {
                preconditionFailure("Cell Register not configured correctily")
            }
            cell.setup(synopsis: "Harry Potter é um garoto órfão que vive infeliz com seus tios, os Dursleys. Ele recebe uma carta contendo um convite para ingressar em Hogwarts, uma famosa escola especializada em formar jovens…", delegate: cellDelegate)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                         withReuseIdentifier: CollectionViewAccessibilityHeader.identifier,
                                                                         for: indexPath) as? CollectionViewAccessibilityHeader
        else {
            preconditionFailure("Header View configured wrong")
        }
        
        if indexPath.section == 0 {
            header.setupAccessibilityLabel(with: "Themes")
        } else {
            header.setupAccessibilityLabel(with: "Synopsis")
        }
        
        return header
    }
    
}

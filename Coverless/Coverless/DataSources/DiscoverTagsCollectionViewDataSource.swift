//
//  DiscoverTagsCollectionViewDataSource.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 27/09/21.
//

import UIKit

final class DiscoverTagsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    let subjects: [Subject] = PropertyListDecoder.decode("Subjects", to: [Subject].self) ?? []
    
    lazy var selectedSubject: Subject? = {
        if subjects.isEmpty {
            return nil
        }
        return subjects[0]
    }() {
        didSet {
            NotificationCenter.default.post(name: DiscoverTagsHeader.dataSourceDidChangeSubject, object: selectedSubject)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        subjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubjectCell.identifier, for: indexPath) as? SubjectCell
        else {
            preconditionFailure("Cell Register not configured correctily")
        }
        
        let isSelected = (selectedSubject == subjects[indexPath.row])
        cell.setup(with: subjects[indexPath.row].name, isSelected: isSelected)
        
        return cell
    }
    
    
}

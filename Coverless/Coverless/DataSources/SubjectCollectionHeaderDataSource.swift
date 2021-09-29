//
//  SubhectCollectionHeaderDataSource.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 28/09/21.
//

import UIKit

final class SubjectCollectionHeaderDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let subjects = PropertyListDecoder.decode("Subjects", to: [Subject].self) ?? []
    
    lazy var selectedSubject: Subject? = {
        if subjects.isEmpty {
            return nil
        } else {
            return subjects[0]
        }
    }() {
        didSet {
            NotificationCenter.default.post(name: .didSelectSubject, object: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubjectCell.identifier, for: indexPath) as? SubjectCell else {
            preconditionFailure("Cell COnfigured in a incorrect manner")
        }
        
        let isSelected = selectedSubject == subjects[indexPath.row]
        cell.setup(with: subjects[indexPath.row].name, isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSubject = subjects[indexPath.row]
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? SubjectCell else {
            return
        }
        updateSubjectCellAppearence(cell, isSelected: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SubjectCell else {
            return
        }
        updateSubjectCellAppearence(cell, isSelected: false)
    }
    
    private func updateSubjectCellAppearence(_ cell: SubjectCell, isSelected: Bool) {
        if isSelected {
            cell.didSelectCell()
        } else {
            cell.didDeselectCell()
        }
    }
}

extension Notification.Name {
    static let didSelectSubject: Notification.Name = Notification.Name("SubjectCollectionHeaderDataSource.didSelectSubject")
}

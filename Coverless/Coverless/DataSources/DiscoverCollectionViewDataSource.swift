//
//  DiscoverCollectionViewDataSource.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 22/09/21.
//

import UIKit

class DiscoverCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    weak var cellDelegate: SynopsisCellDelegate?
    weak var footerDelegate: DiscoverViewFooterDelegate?
    
    private let subjectDataSource: SubjectCollectionHeaderDataSource = .init()
    private let repository: GoogleRepository = .init()
    
    var data: [Book] = []
    
    func fetchBooks(_ completionHandler: @escaping () -> Void) {
        let subject = subjectDataSource.selectedSubject
        
        repository.getBooks(text: subject?.name ?? "") {[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let books):
                self?.data = books
                completionHandler()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SynopsisCell.identifier, for: indexPath) as? SynopsisCell else {
            preconditionFailure("Cell Register not configured correctily")
        }
        cell.setup(book: data[indexPath.row], delegate: cellDelegate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier: SubjectCollectionHeader.identifier,
                                                                             for: indexPath) as? SubjectCollectionHeader
            else {
                preconditionFailure("Header View configured wrong")
            }
            header.setup(dataSource: subjectDataSource)
            return header
            
        } else {
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                               withReuseIdentifier: DiscoverViewFooter.identifier,
                                                                               for: indexPath) as? DiscoverViewFooter
            else {
                preconditionFailure("Footer View configured wrong")
            }
            
            footer.setup(delegate: footerDelegate)
            
            return footer
        }
    }
    
}

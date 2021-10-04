//
//  SynopsisCellDelegate.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 16/09/21.
//

import Foundation

protocol SynopsisCellDelegate: AnyObject {
    func showInfo(for book: Book) -> Void
    func discoverBook(_ book: Book) -> Void
}

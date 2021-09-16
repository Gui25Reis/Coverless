//
//  SynopsisCellDelegate.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 16/09/21.
//

import Foundation

protocol SynopsisCellDelegate: AnyObject {
    func showInfo() -> Void
    func discoverBook() -> Void
}

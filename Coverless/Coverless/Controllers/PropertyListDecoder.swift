//
//  PropertyListDecoder.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 16/09/21.
//

import Foundation

extension PropertyListDecoder {
    
    enum DecodeError: Error {
        case badURL
    }
    
    static func decode<T: Decodable>(_ fileName: String, to model: T.Type) -> T? {
        let decoder = PropertyListDecoder()
        
        guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "plist"),
            let data = try? Data(contentsOf: url, options: .mappedIfSafe),
            let decodedData = try? decoder.decode(T.self, from: data)
        else {
            return nil
        }
        
        return decodedData
        
    }
}

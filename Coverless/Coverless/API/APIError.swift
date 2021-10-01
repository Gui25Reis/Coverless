//
//  APIError.swift
//  Coverless
//
//  Created by Gui Reis on 01/10/21.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case badDecode
    case badData
    
    /// Feedback para o usuário
    var localizedDescription: String {
        switch self {
        case .badURL, .badDecode, .badData:
            return "Sorry, something went wrong."
            
        case .badResponse(_):
            return "Sorry, the connection to our server failed."
            
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong."
        }
    }
    
    /// Feedback completo para desenvolver
    var description: String {
        switch self {
        case .badURL: return "URL inválida"
        case .badData: return "Erro nos dados recebidos"
        case .badDecode: return "Erro na hora de decodificar"
        
        case .url(let error):
            return error?.localizedDescription ?? "Eror na sessão com URL"
            
        case .badResponse(statusCode: let statusCode):
            return "Erro na chamada, status: \(statusCode)"
        }
    }
}

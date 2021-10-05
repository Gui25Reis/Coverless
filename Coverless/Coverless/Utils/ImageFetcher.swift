//
//  ImageFetcher.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 05/10/21.
//

import Foundation
import UIKit

final class ImageFetcher {
    
    enum ImageFetcherErrors: Error {
        case failedToCompress
        case malformedPath
        case failedToWriteIntoDisk
        case badBookURL
        case failedToFetch
    }
    
    static let shared = ImageFetcher()
    
    private let fileManager: FileManager
    private let session: URLSession
    
    init(fileManager: FileManager = FileManager.default, session: URLSession = URLSession.shared) {
        self.fileManager = fileManager
        self.session = session
    }
    
    private var documentDirectory: URL? {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }
    
    func saveImage(from url: URL?, _ completionHandler: @escaping (Result<String, ImageFetcherErrors>) -> Void) {
        guard let url = url else {
            completionHandler(.failure(.badBookURL))
            return
        }
        
        session.dataTask(with: url) {[weak self] data, response, error in
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data),
                let self = self,
                let path = try? self.save(image: image)
            else {
                completionHandler(.failure(.failedToFetch))
                return
            }
            
            completionHandler(.success(path))
        }.resume()

    }
    
    func save(image: UIImage?) throws -> String {
        
        guard let data = image?.jpegData(compressionQuality: 1) else {
            throw ImageFetcherErrors.failedToCompress
        }
        
        let directory = documentDirectory
        let imageID = UUID().uuidString
        let path = directory?.appendingPathComponent("\(imageID).jpeg")
        
        guard let path = path else {
            throw ImageFetcherErrors.malformedPath
        }
        
        do {
            try data.write(to: path)
            return path.lastPathComponent
        } catch {
            throw ImageFetcherErrors.failedToWriteIntoDisk
        }
    }
    
    func image(for fileName: String?) -> UIImage? {
        guard
            let fileName = fileName,
            let imagePath = documentDirectory?.appendingPathComponent(fileName),
            let image = UIImage(contentsOfFile: imagePath.relativePath)
        else {
            return UIImage(named: "ImageBookDefault")
        }

       return image
    }
}

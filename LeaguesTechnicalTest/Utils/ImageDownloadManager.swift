//
//  ImageDownloadManager.swift
//  LeaguesTechnicalTest
//
//  Created by Alexandre Lellouche on 11/12/2022.
//

import Foundation
import UIKit

class ImageDownloadManager {
    
    // MARK: Private propeties
    
    /// URLSession object used to download images
    private let session: URLSession =  {
        var conf = URLSessionConfiguration.default
        
        let cacheSizeMemory: Int = 30*1024*1024; // 30 MB
        let cacheSizeDisk: Int = 500*1024*1024; // 500 MB
        
        let cache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: nil)
        conf.requestCachePolicy = .useProtocolCachePolicy
        conf.urlCache = cache
        let dest = URLSession(configuration: conf)
        return dest
    }()
    
    // MARK: Private methods
    
    private func handleImageResponse(data: Data?, completion:  @escaping ((UIImage?) -> Void)) {
        guard
            let data = data,
            let image = UIImage(data: data) else {
            completion(nil)
            return
        }
        completion(image)
    }
    
    // MARK: Public methods
    
    ///  Clear image on RAM and on the file system
    ///  for a specific URL image ressource
    /// - Parameter url: URL Image ressource to delete from the cache
    func clearCache(for url: URL) {
        let request = URLRequest(url: url)
        self.session.configuration.urlCache?.removeCachedResponse(for: request)
    }
    
    /// Download image from the internet
    /// Before trying to download the image,
    /// The RAM cache and the filesystem will be used in order to retrive the image.
    /// - Parameters:
    ///   - url: URL of the image requested
    ///   - completion: Completion closure, with an optional `UIImage`.
    ///   - forceReload: Remove the local cache for the url parameter before executing the network request
    func imageWith(_ url: URL, forceReload: Bool = false, completion: @escaping ((UIImage?) -> Void)) {
        
        let request = URLRequest(url: url)
        
        if let cachedResponse = self.session.configuration.urlCache?.cachedResponse(for: request) {
            self.handleImageResponse(data: cachedResponse.data, completion: completion)
            return
        }
        
        if forceReload == true {
            self.clearCache(for: url)
        }
        
        self.session.dataTask(with: request) { [weak self] data, _, error in
            guard let `self` = self else { return }
            self.handleImageResponse(data: data, completion: completion)
        }.resume()
    }
}

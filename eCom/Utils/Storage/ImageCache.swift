//
//  ImageCache.swift
//  eCom
//
//  Created by Sumit Kumar Jangra on 03/02/25.
//
import Foundation

protocol ImageCacheProtocol {
    func image(for url: String) -> Data?
    func insert(_ image: Data?, for url: String)
}

class ImageCache: ImageCacheProtocol {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, NSData>()
    
    private init() {
        cache.totalCostLimit = 5 * 1024 * 1024
    }
    
    func image(for url: String) -> Data? {
        cache.object(forKey: url as NSString) as? Data
    }
    
    func insert(_ image: Data?, for url: String) {
        guard let image = image else { return }
        let url = url as NSString
        let imageData = image as NSData
        
        cache.setObject(imageData, forKey: url)
    }
}

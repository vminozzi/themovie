//
//  DetailMovieViewModel.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 18/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation
import UIKit

protocol DetailMovieViewLoadContent: class {
    func didLoadImage()
}

protocol DetailMovieViewModelDelegate: class {
    func getImage() -> UIImage?
    func imageFromCache() -> UIImage?
}

class DetailMovieViewModel: DetailMovieViewModelDelegate {
    
    private var imageId = ""
    weak var loadContentDelegate: DetailMovieViewLoadContent?
    private var cache = NSCache<NSString, UIImage>()
    
    init(delegate: DetailMovieViewLoadContent, imageId: String) {
        loadContentDelegate = delegate
        self.imageId = BaseAPI.imageURL + imageId
    }
    
    // MARK: - CachedImageLoadContent
    func didLoadImage(identifier: String) {
        loadContentDelegate?.didLoadImage()
    }
    
    func getImage() -> UIImage? {
        if let imageCached = cache.object(forKey: NSString(string: imageId)) {
            return imageCached
        }
        
        let placeholder = UIImage(named: "placeholder-icon")
        placeholder?.accessibilityIdentifier = "placeholder"
        cache.setObject(placeholder ?? UIImage(), forKey: NSString(string: imageId))
        
        if let url = URL(string: imageId) {
            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: NSString(string: self.imageId))
                        self.loadContentDelegate?.didLoadImage()
                    }
                }
            }).resume()
        }
        return nil
    }
    
    func imageFromCache() -> UIImage? {
        return cache.object(forKey: NSString(string: imageId))
    }
}

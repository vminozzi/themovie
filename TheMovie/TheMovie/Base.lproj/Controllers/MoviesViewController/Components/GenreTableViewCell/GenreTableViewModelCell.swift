//
//  GenreTableViewModelCell.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation
import UIKit

protocol GenreCellLoadContent: class {
    func didLoadImage(identifier: String)
    func didLoadContent()
}

protocol GenreCellViewModelDelegate: class {
    func setMovies(array: [Movie], genreId: Int)
    func numberOfSections() -> Int
    func numberOfItems() -> Int
    func sizeForItems() -> CGSize
    func getMovieDTO(at row: Int) -> MovieDTO
    func imageFromCache(identifier: String) -> UIImage?
}

class GenreTableViewModelCell: GenreCellViewModelDelegate {
    
    private var cache = NSCache<NSString, UIImage>()
    private weak var loadContentDelegate: GenreCellLoadContent?
    private var movies = [Movie]()
    private var genreId = 0
    
    init(delegate: GenreCellLoadContent?) {
        loadContentDelegate = delegate
    }
    
    func setMovies(array: [Movie], genreId: Int) {
        movies = array
        self.genreId = genreId
        loadContentDelegate?.didLoadContent()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems() -> Int {
        return movies.count
    }
    
    func getImage(row: Int) -> UIImage? {
        let imageString = BaseAPI.imageURL + (movies[row].poster_path ?? "") + "\(genreId)"
        if let imageCached = cache.object(forKey: NSString(string: imageString)) {
            return imageCached
        }
        
        let placeholder = UIImage(named: "placeholder-icon")
        placeholder?.accessibilityIdentifier = "placeholder"
        cache.setObject(placeholder ?? UIImage(), forKey: NSString(string: imageString))
        
        if let url = URL(string: BaseAPI.imageURL + (movies[row].poster_path ?? "")) {
            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    self.cache.setObject(image, forKey: NSString(string: imageString))
                    self.loadContentDelegate?.didLoadImage(identifier: imageString)
                }
            }).resume()
        }
        return nil
    }
    
    func imageFromCache(identifier: String) -> UIImage? {
        return cache.object(forKey: NSString(string: identifier))
    }
    
    func getMovieDTO(at row: Int) -> MovieDTO {
        return MovieDTO(id: movies[row].id ?? 0,
                        name: movies[row].title ?? "",
                        identifier: BaseAPI.imageURL + (movies[row].poster_path ?? "") + "\(genreId)",
                        image: getImage(row: row))
    }
    
    func sizeForItems() -> CGSize {
        return CGSize(width: 150.0, height: 265.0)
    }
}

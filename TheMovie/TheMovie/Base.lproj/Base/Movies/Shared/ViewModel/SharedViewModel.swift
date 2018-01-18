//
//  SharedViewModel.swift
//  TheMovie
//
//  Created by Vinicius on 17/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation
import UIKit

protocol SharedLoadContent: class {
    func didLoadImage(identifier: String)
    func didLoadContent(error: String?)
}

protocol SharedViewModelDelegate: class {
    
    var genreId: Int { get }
    var title: String { get }
    var movies: [Movie] { set get }
    
    func setGenreDTO(with dto: GenreDTO)
    func getMovieDTO(at row: Int) -> MovieDTO
    func getImage(row: Int) -> UIImage?
    func imageFromCache(identifier: String) -> UIImage?
}


class SharedViewModel: SharedViewModelDelegate {
    
    var genreId = 0
    var movies = [Movie]()
    var title = ""
    private var cache = NSCache<NSString, UIImage>()
    weak var loadContentDelegate: SharedLoadContent?
    
    init() { }
    
    init(sharedDelegate: SharedLoadContent) {
        self.loadContentDelegate = sharedDelegate
    }
    
    func setGenreDTO(with dto: GenreDTO) {
        movies = dto.movies
        title = dto.name
        genreId = dto.id
    }
    
    func getMovieDTO(at row: Int) -> MovieDTO {
        return MovieDTO(id: movies[row].id ?? 0,
                        name: movies[row].title ?? "",
                        identifier: BaseAPI.imageURL + (movies[row].poster_path ?? "") + "\(genreId)",
                        image: getImage(row: row))
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
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: NSString(string: imageString))
                        self.loadContentDelegate?.didLoadImage(identifier: imageString)
                    }
                }
            }).resume()
        }
        return nil
    }
    
    func imageFromCache(identifier: String) -> UIImage? {
        return cache.object(forKey: NSString(string: identifier))
    }
}

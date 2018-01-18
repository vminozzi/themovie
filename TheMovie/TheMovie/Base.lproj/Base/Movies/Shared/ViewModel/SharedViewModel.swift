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
    func didShowMovieDetail(with dto: DetailMovieDTO, error: String?)
}

protocol SharedViewModelDelegate: class {
    
    var genreId: Int { get }
    var title: String { get }
    var movies: [Movie] { set get }
    
    func setGenreDTO(with dto: GenreDTO)
    func getMovieDTO(at row: Int) -> MovieDTO
    func getImage(row: Int) -> UIImage?
    func imageFromCache(identifier: String) -> UIImage?
    func movieDetail(at row: Int)
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
        loadContentDelegate?.didLoadContent(error: nil)
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
    
    func movieDetail(at row: Int) {
        DetailRequest(movie: movies[row].id ?? 0).request { result, error in
            
            let detailDTO = DetailMovieDTO(image: result?.detail?.backdrop_path ?? "",
                                           overview: result?.detail?.overview ?? "",
                                           title: result?.detail?.title ?? "",
                                           avarage: result?.detail?.vote_average ?? 0.0,
                                           avaregeCount: result?.detail?.vote_count ?? 0)
            
            self.loadContentDelegate?.didShowMovieDetail(with: detailDTO, error: error?.message)
        }
    }
}

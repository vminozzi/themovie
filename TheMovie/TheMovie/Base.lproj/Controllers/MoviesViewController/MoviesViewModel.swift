//
//  MoviesViewModel.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

struct GenreDTO {
    var id = 0
    var name = ""
    var movies = [Movie]()
}

protocol LoadContent: class {
    func didLoadContent(error: String?)
}

protocol MoviesDelegate: class {
    func loadContent()
    func numberOfSections() -> Int
    func numberOfRows() -> Int
    func getGenreDTO(at row: Int) -> GenreDTO?
    func getTitle(at section: Int) -> String
}

class MoviesViewModel: MoviesDelegate {
    
    private var genres: [Genre]?
    private var movies: [Movie]?
    private weak var loadContentDelegate: LoadContent?
    
    init(delegate: LoadContent?) {
        loadContentDelegate = delegate
    }
    
    func loadContent() {
        GenreRequest().request { result, error in
            self.genres = result?.genres
            self.loadContentDelegate?.didLoadContent(error: error?.message)
            self.movies = [Movie]()
            self.genres?.forEach { self.getMovies(with: $0.id) }
        }
    }
    
    func numberOfSections() -> Int {
        return genres?.count ?? 0
    }
    
    func numberOfRows() -> Int {
        return 1
    }
    
    func getTitle(at section: Int) -> String {
        return genres?[section].name ?? ""
    }
    
    func getGenreDTO(at row: Int) -> GenreDTO? {
        return GenreDTO(id: genres?[row].id ?? 0, name: genres?[row].name ?? "", movies: getMovies(from: genres?[row].id ?? 0))
    }
    
    private func getMovies(from id: Int) -> [Movie] {
        let filtered = movies?.filter { $0.genre_ids?.contains(id) == true }
        guard let movies = filtered else {
            return [Movie]()
        }
        return movies
    }
    
    private func getMovies(with gerne: Int) {
        MoviesRequest(page: 1, genre: gerne).request(completion: { movies, error in
            movies?.results?.forEach { self.movies?.append($0) }
            self.loadContentDelegate?.didLoadContent(error: error?.message)
        })
    }
}

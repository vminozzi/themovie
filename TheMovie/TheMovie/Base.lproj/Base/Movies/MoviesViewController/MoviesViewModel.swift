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

typealias GenreMovie = (genre: Int, movies: [Movie]?)

class MoviesViewModel: MoviesDelegate {
    
    private var genres: [Genre]?
    private var genreMovies = [GenreMovie]()
    private weak var loadContentDelegate: LoadContent?
    
    init(delegate: LoadContent?) {
        loadContentDelegate = delegate
    }
    
    func loadContent() {
        GenreRequest().request { result, error in
            self.genres = result?.genres
            self.loadContentDelegate?.didLoadContent(error: error?.message)
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
        let moviesSection = genreMovies.filter { $0.genre == id }.first
        guard let movies = moviesSection?.movies else {
            return [Movie]()
        }
        return movies
    }
    
    private func getMovies(with gerne: Int) {
        MoviesRequest(page: 1, genre: gerne).request(completion: { movies, error in
            self.genreMovies.append(GenreMovie(genre: gerne, movies: movies?.results))
            self.loadContentDelegate?.didLoadContent(error: error?.message)
        })
    }
}

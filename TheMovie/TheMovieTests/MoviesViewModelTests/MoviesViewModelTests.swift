//
//  MoviesViewModelTests.swift
//  TheMovieTests
//
//  Created by Vinicius on 19/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import XCTest
@testable import TheMovie

class MoviesViewModelTests: XCTestCase {
    
    let moviesViewModel = MoviesViewModel()
    var movies: [Movie]?
    
    override func setUp() {
        super.setUp()
        
        guard let dataGerne = readJSON(name: "MockedGenre"), let mockedGerne = GenreResult(data: dataGerne) else {
            return
        }
        moviesViewModel.genres = mockedGerne.genres
        
        guard let data = readJSON(name: "Mock"), let mockedMovies = MoviesResult(data: data) else {
            return
        }
        movies = mockedMovies.results
        let genreMovies = GenreMovie(genre: 28, movies: movies)
        moviesViewModel.genreMovies.append(genreMovies)
    }
    
    func testShouldValidateNumberOfSections() {
        XCTAssertEqual(moviesViewModel.numberOfSections(), 19)
    }
    
    func testShouldValidateNumberOfIRows() {
        XCTAssertEqual(moviesViewModel.numberOfRows(), 1)
    }
    
    func testShouldValidateGetGerneDTO() {
        XCTAssertEqual(moviesViewModel.getGenreDTO(at: 0)?.id, 28)
        XCTAssertEqual(moviesViewModel.getGenreDTO(at: 0)?.name, "Ação")
    }
    
    func testShouldValidateGetMoviesFromGerneId() {
        XCTAssert(moviesViewModel.getMovies(from: 28).count > 0)
    }
}

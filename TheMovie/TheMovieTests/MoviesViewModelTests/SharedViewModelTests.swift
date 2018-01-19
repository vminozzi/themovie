//
//  TheMovieTests.swift
//  TheMovieTests
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import XCTest
@testable import TheMovie

class SharedViewModelTests: XCTestCase {
    
    private var sharedViewModel = SharedViewModel()
    
    override func setUp() {
        super.setUp()
        
        guard let data = readJSON(name: "Mock") else {
            return
        }
        let mockedMovies = MoviesResult(data: data)
        sharedViewModel.setGenreDTO(with: GenreDTO(id: 16,
                                                   name: "",
                                                   movies: mockedMovies?.results ?? [Movie]()))
    }
    
    func testShouldValidateGetMovieDTO() {
        let identifier = BaseAPI.imageURL + (sharedViewModel.movies[0].poster_path ?? "") + "\(sharedViewModel.genreId)"
        XCTAssertEqual(sharedViewModel.getMovieDTO(at: 0).id, 460793)
        XCTAssertEqual(sharedViewModel.getMovieDTO(at: 0).name, "Olaf: Em Uma Nova Aventura Congelante de Frozen")
        XCTAssertEqual(sharedViewModel.getMovieDTO(at: 0).identifier, identifier)
    }
}

extension XCTestCase {
    
    func readJSON(name: String) -> Data? {
        let path = Bundle.main.path(forResource: name, ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        return data
    }
}

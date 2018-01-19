//
//  ListViewModelTests.swift
//  TheMovieTests
//
//  Created by Vinicius on 19/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import XCTest
@testable import TheMovie

class ListViewModelTests: XCTestCase {
    
    var listViewModel = ListMoviesViewModel()
    
    override func setUp() {
        super.setUp()
        
        guard let data = readJSON(name: "Mock") else {
            return
        }
        let mockedMovies = MoviesResult(data: data)
        let sharedViewModel = SharedViewModel()
        sharedViewModel.setGenreDTO(with: GenreDTO(id: 16,
                                                   name: "",
                                                   movies: mockedMovies?.results ?? [Movie]()))
        listViewModel.sharedViewModel = sharedViewModel
    }
    
    func testShouldValidateNumberOfSections() {
        XCTAssertEqual(listViewModel.numberOfSections(), 1)
    }
    
    func testShouldValidateNumberOfItems() {
        XCTAssertEqual(listViewModel.numberOfItems(), 20)
    }
}

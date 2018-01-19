//
//  MoviesResultModelTests.swift
//  TheMovieTests
//
//  Created by Vinicius on 19/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import XCTest
@testable import TheMovie

class MoviesResultModelTests: XCTestCase {
    
    var result: MoviesResult?
    
    override func setUp() {
        super.setUp()
        
        guard let data = readJSON(name: "Mock"), let mocked = MoviesResult(data: data) else {
            return
        }
        result = mocked
    }
    
    func testShouldValidateDeserialize() {
        XCTAssert(result?.results?.count ?? 0 > 0)
        XCTAssert(result?.results?[0].id == 460793)
        XCTAssert(result?.results?[0].poster_path == "/cjiJUyLpLuyQZO3sbIlTsvQioEj.jpg")
        XCTAssert(result?.results?[0].title == "Olaf: Em Uma Nova Aventura Congelante de Frozen")
        XCTAssert(result?.results?[0].vote_count == 314)
    }
}

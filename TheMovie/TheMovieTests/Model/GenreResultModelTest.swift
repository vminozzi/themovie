//
//  GenreResultModelTest.swift
//  TheMovieTests
//
//  Created by Vinicius on 19/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import XCTest
@testable import TheMovie

class GenreResultModelTest: XCTestCase {
    
    var result: GenreResult?
    
    override func setUp() {
        super.setUp()
        
        guard let data = readJSON(name: "MockedGenre"), let mocked = GenreResult(data: data) else {
            return
        }
        result = mocked
    }
    
    func testShouldValidateDeserialize() {
        XCTAssert(result?.genres?[0].id == 28)
        XCTAssert(result?.genres?[0].name == "Ação")
    }
}

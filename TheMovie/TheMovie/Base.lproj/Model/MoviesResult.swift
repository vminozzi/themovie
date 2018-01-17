//
//  MoviesResult.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

struct MoviesResult: Mappable {
    
    var results: [Movie]?
    
    init?(data: Data) {
        guard let moviesDecoded = try? JSONDecoder().decode(MoviesResult.self, from: data) else {
            return nil
        }
        results = moviesDecoded.results
    }
}

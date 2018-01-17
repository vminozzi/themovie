//
//  File.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

struct GenreResult: Mappable {
    
    var genres: [Genre]?
    
    init?(data: Data) {
        guard let genresDecoded = try? JSONDecoder().decode(GenreResult.self, from: data) else {
            return nil
        }
        genres = genresDecoded.genres
    }
}

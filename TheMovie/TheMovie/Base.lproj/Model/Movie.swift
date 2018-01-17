//
//  Movie.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

struct Movie: Mappable {
    
    var id: Int?
    var vote_count: Int?
    var title: String?
    var poster_path: String?
    var genre_ids: [Int]?
    var overview: String?
    
    init?(data: Data) {
        
    }
}

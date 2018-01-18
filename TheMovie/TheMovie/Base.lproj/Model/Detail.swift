//
//  Detail.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 18/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

struct Detail: Mappable {
    
    var id = 0
    var overview = ""
    var title = ""
    var vote_average = 0.0
    var vote_count = 0
    var backdrop_path = ""
    
    init?(data: Data) {
        
    }
}

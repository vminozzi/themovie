//
//  ResultDetail.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 18/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

struct ResultDetail: Mappable {
    
    var detail: Detail?
    
    init?(data: Data) {
        guard let detailDecoded = try? JSONDecoder().decode(Detail.self, from: data) else {
            return nil
        }
        detail = detailDecoded
    }
}

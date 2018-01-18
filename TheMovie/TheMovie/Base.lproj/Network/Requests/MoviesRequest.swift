//
//  MoviesRequest.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation
import Alamofire

class MoviesRequest: Requestable {
    
    private var page: Int
    private var genre: Int
    
    init(page: Int, genre: Int) {
        self.page = page
        self.genre = genre
    }
    
    func request(completion: @escaping (MoviesResult?, CustomError?) -> Void) {
        
        let parameters = ["api_key": BaseAPI.key, "language": BaseAPI.language, "page": page] as [String : Any]
        
        guard let moviesURL = URL(string: BaseAPI().movies + "\(genre)/movies") else {
            completion(nil, CustomError())
            return
        }
        
        Alamofire.request(moviesURL, method: .get, parameters: parameters).validate().responseJSON { response in
            let result = response.data <--> (MoviesResult.self, response.error)
            completion(result.model, result.error)
            }.resume()
    }
}

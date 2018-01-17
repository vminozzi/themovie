//
//  GenrerRequest.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation
import Alamofire

class GenreRequest: Requestable {
    
    func request(completion: @escaping (GenreResult?, CustomError?) -> Void) {
        let parameters = ["api_key": BaseAPI.key, "language": BaseAPI.language] as [String : Any]
        
        guard let moviesURL = URL(string: BaseAPI().genres) else {
            completion(nil, CustomError())
            return
        }
        
        Alamofire.request(moviesURL, method: .get, parameters: parameters).validate().responseJSON { response in
            
            let result = response.data <--> (GenreResult.self, response.error)
            completion(result.model, result.error)
            
            }.resume()
    }
}

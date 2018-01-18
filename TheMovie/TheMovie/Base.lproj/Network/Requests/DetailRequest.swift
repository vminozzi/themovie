//
//  DetailRequest.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 18/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation
import Alamofire

class DetailRequest: Requestable {
    
    private var id = 0
    
    init(movie id: Int) {
        self.id = id
    }
    
    func request(completion: @escaping (ResultDetail?, CustomError?) -> Void) {
        let parameters = ["api_key": BaseAPI.key, "language": BaseAPI.language] as [String : Any]
        
        guard let moviesURL = URL(string: BaseAPI().movie + "\(id)") else {
            completion(nil, CustomError())
            return
        }
        
        Alamofire.request(moviesURL, method: .get, parameters: parameters).validate().responseJSON { response in
            let result = response.data <--> (ResultDetail.self, response.error)
            completion(result.model, result.error)
            }.resume()
    }
}

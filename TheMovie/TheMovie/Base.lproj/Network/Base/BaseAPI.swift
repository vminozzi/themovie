//
//  BaseAPI.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

protocol Mappable: Decodable {
    init?(data: Data)
}

protocol Requestable: class {
    associatedtype DataType
    func request(completion: @escaping (_ result: DataType?, _ error: CustomError?) -> Void)
}

struct BaseAPI {
    
    static var imageURL = "https://image.tmdb.org/t/p/w320"
    static var key = "92780cb6b9da5c0a7fc471d31864d2b1"
    static var language = "pt-BR"
    
    private var base = "https://api.themoviedb.org/3/"
    
    var movies: String {
        return base + "genre/"
    }
    
    var genres: String {
        return base + "genre/movie/list"
    }
    
    var movie: String {
        return base + "movie/"
    }
}

precedencegroup ExponentiativePrecedence {
    associativity: right
    higherThan: MultiplicationPrecedence
}

infix operator <--> :ExponentiativePrecedence

func <--> <T: Mappable>(data: Data?, handle: (type: T.Type, error: Error?)) -> (model: T?, error: CustomError?) {
    
    if let error = handle.error {
        return (nil, CustomError(error: error))
    }
    
    guard let data = data else {
        return (nil, CustomError(error: handle.error))
    }
    
    guard let model = T(data: data) else {
        return (nil, CustomError())
    }
    
    return (model, nil)
}

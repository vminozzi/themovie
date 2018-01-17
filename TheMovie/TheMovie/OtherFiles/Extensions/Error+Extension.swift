//
//  Error+Extension.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

struct CustomError {
    
    var message = "Ops... ocorreu algum erro =("
    
    init() { }
    
    init(error: Error?) {
        message = error?.localizedDescription ?? ""
    }
}

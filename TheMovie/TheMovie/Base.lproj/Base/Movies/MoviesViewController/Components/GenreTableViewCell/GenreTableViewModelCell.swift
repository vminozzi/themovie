//
//  GenreTableViewModelCell.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation
import UIKit

protocol GenreViewModelDelegate: class {
    
    var sharedViewModel: SharedViewModel { get }
    
    func numberOfSections() -> Int
    func numberOfItems() -> Int
    func sizeForItems(with width: CGFloat, height: CGFloat) -> CGSize
}

class GenreTableViewModelCell: GenreViewModelDelegate {
    
    var sharedViewModel = SharedViewModel()
    
    init(delegate: SharedLoadContent) {
        sharedViewModel = SharedViewModel(sharedDelegate: delegate)
    }
    
    func setMovies(dto: GenreDTO) {
        sharedViewModel.setGenreDTO(with: dto)
        sharedViewModel.loadContentDelegate?.didLoadContent(error: nil)
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems() -> Int {
        return sharedViewModel.movies.count < 10 ? sharedViewModel.movies.count : 10
    }
    
    func sizeForItems(with width: CGFloat, height: CGFloat) -> CGSize {
        return CGSize(width: 128.0, height: 242.0)
    }
}

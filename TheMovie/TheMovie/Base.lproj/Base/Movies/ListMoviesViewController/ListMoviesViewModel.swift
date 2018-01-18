//
//  ListMoviesViewModel.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 17/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation
import UIKit

protocol ListMoviesViewModelDelegate: class {
    
    var sharedViewModel: SharedViewModel { get }
    
    func loadContent()
    func numberOfSections() -> Int
    func numberOfItems() -> Int
    func sizeForItems(with width: CGFloat, height: CGFloat) -> CGSize
}

class ListMoviesViewModel: ListMoviesViewModelDelegate {
    
    var sharedViewModel = SharedViewModel()
    private var page = 1
    
    
    init(delegate: SharedLoadContent) {
        sharedViewModel = SharedViewModel(sharedDelegate: delegate)
    }
    
    
    // MARK: - MovieByGenreViewModelDelegate
    func loadContent() {
        page += 1
        MoviesRequest(page: page, genre: sharedViewModel.genreId).request(completion: { movies, error in
            movies?.results?.forEach { self.sharedViewModel.movies.append($0) }
            self.sharedViewModel.loadContentDelegate?.didLoadContent(error: error?.message)
        })
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems() -> Int {
        return sharedViewModel.movies.count
    }
    
    func sizeForItems(with width: CGFloat, height: CGFloat) -> CGSize {
        return CGSize(width: ((width / 2) - 24), height: ((height / 2) - 24))
    }
}

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
    private var canLoadContent = true
    
    init() { }
    
    init(delegate: SharedLoadContent) {
        sharedViewModel = SharedViewModel(sharedDelegate: delegate)
    }
    
    
    // MARK: - MovieByGenreViewModelDelegate
    func loadContent() {
        if canLoadContent {
            page += 1
            MoviesRequest(page: page, genre: sharedViewModel.genreId).request(completion: { movies, error in
                self.canLoadContent = movies?.total_pages != self.page
                movies?.results?.forEach { self.sharedViewModel.movies.append($0) }
                self.sharedViewModel.loadContentDelegate?.didLoadContent(error: error?.message)
            })
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems() -> Int {
        return sharedViewModel.movies.count
    }
    
    func sizeForItems(with width: CGFloat, height: CGFloat) -> CGSize {
        return CGSize(width: ((width / 2) - 12), height: ((height / 2) - 12))
    }
}

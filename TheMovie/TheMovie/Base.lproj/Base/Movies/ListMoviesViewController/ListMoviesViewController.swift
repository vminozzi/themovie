//
//  ListMoviesViewController.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 17/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import UIKit

class ListMoviesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SharedLoadContent {
    
    // MARK: - Attributes
    lazy var viewModel: ListMoviesViewModelDelegate = ListMoviesViewModel(delegate: self)
    private var genreDTO = GenreDTO()
    
    
    // MARK: - Instace methods
    override func viewDidLoad() {
        super.viewDidLoad()
        populate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func populate() {
        viewModel.sharedViewModel.setGenreDTO(with: genreDTO)
        self.title = viewModel.sharedViewModel.title
    }
    
    func fill(with dto: GenreDTO) {
        genreDTO = dto
    }
    
    
    // MARK: - MovieByGenreLoadContent
    func didLoadContent(error: String?) {
        dismissLoader()
        if let errorMessage = error {
            showDefaultAlert(message: errorMessage, completeBlock: nil)
        } else {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func didLoadImage(identifier: String) {
        DispatchQueue.main.async {
            guard let collection = self.collectionView else {
                return
            }
            for cell in collection.visibleCells {
                if let movieCell = cell as? MovieCollectionViewCell, movieCell.identifier == identifier {
                    movieCell.setImage(with: self.viewModel.sharedViewModel.imageFromCache(identifier: identifier))
                }
            }
        }
    }

    
    // MARK: UICollectionViewDataSource/Delegate
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MovieCollectionViewCell.createCell(collectionView: collectionView, indexPath: indexPath) as MovieCollectionViewCell
        cell.fill(with: viewModel.sharedViewModel.getMovieDTO(at: indexPath.row))
        if indexPath.row == viewModel.numberOfItems() - 1 {
            showLoader()
            viewModel.loadContent()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let movieCell = cell as? MovieCollectionViewCell {
            movieCell.fill(with: viewModel.sharedViewModel.getMovieDTO(at: indexPath.row))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItems(with: view.frame.size.width, height: view.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}

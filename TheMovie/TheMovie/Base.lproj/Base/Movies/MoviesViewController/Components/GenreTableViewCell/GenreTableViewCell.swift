//
//  GenreTableViewCell.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import UIKit

protocol GenreCellDelegate: class {
    func goToMovies(from genreId: Int, at row: Int)
    func goToMovieDetail(dto: DetailMovieDTO)
    func error(message: String)
    func didShowLoader()
}

class GenreTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, SharedLoadContent {
    
    private lazy var cellViewModel: GenreViewModelDelegate = GenreTableViewModelCell(delegate: self)
    weak var delegate: GenreCellDelegate?
    private var row = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fill(with dto: GenreDTO?, at row: Int) {
        guard let data = dto else {
            return
        }
        self.row = row
        cellViewModel.sharedViewModel.setGenreDTO(with: data)
    }
    
    @IBAction func goToGenre() {
        delegate?.goToMovies(from: cellViewModel.sharedViewModel.genreId, at: row)
    }
    
    
    // MARK: - UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cellViewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MovieCollectionViewCell.createCell(collectionView: collectionView, indexPath: indexPath) as MovieCollectionViewCell
        cell.fill(with: cellViewModel.sharedViewModel.getMovieDTO(at: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let movieCell = cell as? MovieCollectionViewCell {
            movieCell.fill(with: cellViewModel.sharedViewModel.getMovieDTO(at: indexPath.row))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didShowLoader()
        cellViewModel.sharedViewModel.movieDetail(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellViewModel.sizeForItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    
    // MARK: - SharedLoadContent
    func didLoadImage(identifier: String) {
        DispatchQueue.main.async {
            for cell in self.collectionView.visibleCells {
                if let movieCell = cell as? MovieCollectionViewCell, movieCell.identifier == identifier {
                    movieCell.setImage(with: self.cellViewModel.sharedViewModel.imageFromCache(identifier: identifier))
                }
            }
        }
    }
    
    func didLoadContent(error: String?) {
        if let message = error {
            delegate?.error(message: message)
        }
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func didShowMovieDetail(with dto: DetailMovieDTO, error: String?) {
        delegate?.goToMovieDetail(dto: dto)
    }
}

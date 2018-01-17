//
//  GenreTableViewCell.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import UIKit

protocol GenreCellDelegate: class {
    func goToMovies(from genreId: Int)
}

class GenreTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, GenreCellLoadContent {
    
    private lazy var cellViewModel: GenreCellViewModelDelegate = GenreTableViewModelCell(delegate: self)
    weak var delegate: GenreCellDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fill(with dto: GenreDTO?) {
        guard let data = dto else {
            return
        }
        cellViewModel.setMovies(array: data.movies, genreId: data.id)
    }
    
    @IBAction func goToGenre() {
        
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
        cell.fill(with: cellViewModel.getMovieDTO(at: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellViewModel.sizeForItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    
    // MARK: - GenreCellLoadContent
    func didLoadImage(identifier: String) {
        DispatchQueue.main.async {
            for cell in self.collectionView.visibleCells {
                if let movieCell = cell as? MovieCollectionViewCell, movieCell.identifier == identifier {
                    movieCell.setImage(with: self.cellViewModel.imageFromCache(identifier: identifier))
                }
            }
        }
    }
    
    func didLoadContent() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

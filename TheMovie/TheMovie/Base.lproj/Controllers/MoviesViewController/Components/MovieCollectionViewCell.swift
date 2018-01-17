//
//  MovieCollectionViewCell.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import UIKit

struct MovieDTO {
    var id = 0
    var name = ""
    var identifier = ""
    var image: UIImage?
}

class MovieCollectionViewCell: UICollectionViewCell {
    
    var identifier: String?
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fill(with dto: MovieDTO?) {
        guard let data = dto else {
            return
        }
        
        identifier = data.identifier
    }
    
    func setImage(with image: UIImage?) {
        poster.image = image
    }
}

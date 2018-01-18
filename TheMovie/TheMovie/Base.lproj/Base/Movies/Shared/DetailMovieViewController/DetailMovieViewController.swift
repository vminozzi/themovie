//
//  DetailMovieViewController.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 18/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import UIKit

struct DetailMovieDTO {
    var image = ""
    var overview = ""
    var title = ""
    var avarage = 0.0
    var avaregeCount = 0
}

class DetailMovieViewController: UITableViewController, DetailMovieViewLoadContent {
    
    lazy var viewModel: DetailMovieViewModelDelegate = DetailMovieViewModel(delegate: self, imageId: data.image)
    var data = DetailMovieDTO()
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avarage: UILabel!
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func populate() {
        name.text = data.title
        avarage.text = data.avarage != 0.0 ? "Avaliação: \(data.avarage)" + " - (\(data.avaregeCount))" : ""
        overview.text = data.overview
        about.text = data.overview.isEmpty ? "" : "Sobre o filme"
        poster.image = viewModel.getImage()
    }
    
    func fill(with dto: DetailMovieDTO) {
        data = dto
    }
    
    
    // MARK: - DetailMovieViewLoadContent
    func didLoadImage() {
        poster.image = viewModel.imageFromCache()
    }
}

//
//  MoviesViewController.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoadContent, GenreCellDelegate {
    
    
    // MARK: - Attributes
    lazy var viewModel: MoviesDelegate = MoviesViewModel(delegate: self)
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Instace methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            if let detailViewcontroller = segue.destination as? DetailMovieViewController, let dto = sender as? DetailMovieDTO {
                detailViewcontroller.fill(with: dto)
            }
        } else if segue.identifier == "goToList" {
            if let listViewcontroller = segue.destination as? ListMoviesViewController, let dto = sender as? GenreDTO {
                listViewcontroller.fill(with: dto)
            }
        }
    }
    
    
    // MARK: - LoadContent
    func didLoadContent(error: String?) {
        if let error = error {
            showDefaultAlert(message: error, completeBlock: nil)
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GenreTableViewCell.createCell(tableView: tableView, indexPath: indexPath) as GenreTableViewCell
        cell.delegate = self
        cell.fill(with: viewModel.getGenreDTO(at: indexPath.section), at: indexPath.section)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 311.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getTitle(at: section)
    }
    
    
    // MARK: - GenreCellDelegate
    func goToMovies(from genreId: Int, at row: Int) {
        performSegue(withIdentifier: "goToList", sender: viewModel.getGenreDTO(at: row))
    }
    
    func error(message: String) {
        showDefaultAlert(message: "\(message). Tentar novamente?") { alertAction in
            self.viewModel.loadContent()
        }
    }
    
    func goToMovieDetail(dto: DetailMovieDTO) {
        dismissLoader()
        performSegue(withIdentifier: "goToDetail", sender: dto)
    }
    
    func didShowLoader() {
        showLoader()
    }
}

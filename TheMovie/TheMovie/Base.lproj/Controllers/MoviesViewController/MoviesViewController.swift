//
//  MoviesViewController.swift
//  TheMovie
//
//  Created by Vinicius Minozzi on 16/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoadContent, GenreCellDelegate {
    
    lazy var viewModel: MoviesDelegate = MoviesViewModel(delegate: self)
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        cell.fill(with: viewModel.getGenreDTO(at: indexPath.section))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getTitle(at: section)
    }
    
    
    // MARK: - GenreCellDelegate
    func goToMovies(from genreId: Int) {
        // TODO: go to movies list
    }
}

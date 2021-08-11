//
//  MovieController.swift
//  MyMovie
//
//  Created by Antonio Fernández Martín on 26/08/2019.
//  Copyright © 2019 Antonio Fernández Martín. All rights reserved.
//

import UIKit
import SDOSLoader

protocol MovieControllerDelegate {
    
    func showLoadingView()
    func removeLoadingView()
    
    func successSearch(movies: MovieDto?)
    func failed(error: String)
    
}

class MovieController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var contentView: UIView!
    @IBOutlet var movieTableView: UITableView!
    
    var moviesDto: MovieDto?
    private var presenter: MoviesPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MoviesPresenter(ui: self)
        
        movieTableView.sectionHeaderHeight = 0.0
        movieTableView.sectionFooterHeight = 0.0
        movieTableView.tableFooterView = UIView(frame:CGRect.zero)
        
        self.view.backgroundColor = .lightGray
    }
    
}


//MARK: - DelegateClass
extension MovieController: MovieControllerDelegate {
    
    func showLoadingView(){
        LoaderManager.showLoader(LoaderManager.loader(loaderType: .indeterminateCircular(.none), inView: self.view, size: CGSize(width: 50, height: 50)))
    }
    
    func removeLoadingView(){
        DispatchQueue.main.async(execute: { [weak self] in
            guard let self = self else { return }
            do {
                LoaderManager.hideLoaderOfView(self.view)
            }
        })
    }
    
    func successSearch(movies: MovieDto?) {
        presenter?.removeLoadingView()
        guard let movies = movies else {
            return
        }
        moviesDto = movies
        movieTableView.reloadData()
    }
    
    func failed(error: String) {
        let alert = UIAlertController(title: error, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
}

//MARK: - SearchBarDelegate
extension MovieController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        if searchText.count > 3 {
            presenter?.showLoadingView()
            presenter?.searchMovie(parameters: Utilities.getParametersSearchMovie(movieTitle: self.searchBar.text!), body: [:])
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        
        presenter?.searchMovie(parameters: Utilities.getParametersSearchMovie(movieTitle: self.searchBar.text!), body: [:])
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
}


//MARK: - TableViewDelegate
extension MovieController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieCell.heightCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let moviesDto = moviesDto, let searchDto = moviesDto.search else {
            return 0
        }
        return searchDto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let movieCell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "movieCell")
        }
        
        guard let moviesDto = moviesDto, let searchDto = moviesDto.search else {
            return UITableViewCell()
        }
        
        movieCell.setCellValues(movieImage: searchDto[indexPath.row].poster ?? "", movieTitle: searchDto[indexPath.row].title ?? "", movieYear: searchDto[indexPath.row].year ?? "")
        
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "movieDetailController") as? MovieDetailController else {
            return
        }
        guard let searchDto = moviesDto?.search else {
            return
        }
        movieDetailViewController.imdbID = searchDto[indexPath.row].imdbID ?? ""
        self.navigationController?.pushViewController(movieDetailViewController, animated: false)
    }
    
}

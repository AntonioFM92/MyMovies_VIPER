//
//  RecommendedMoviesTableViewController.swift
//  MyMovies
//
//  Created by Antonio Fernández Martín on 21/09/2020.
//  Copyright © 2020 Antonio Fernández Martín. All rights reserved.
//

import UIKit
import SDOSLoader

protocol RecommendedMoviesControllerDelegate {
    func showLoadingView()
    func removeLoadingView()
    
    func success(movies: [RecommendedMovie]?)
    func failed(error: String)
}
class RecommendedMoviesTableViewController: UITableViewController {

    var recommendedMovies: [String : AnyObject] = [:]
    var movies: [RecommendedMovie] = []
    private var presenter: RecommendedMoviesPresenterDelegate?
    
    @IBOutlet var recommendedFilmsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = RecommendedMoviesPresenter(ui: self)
        
        recommendedFilmsTableView.sectionHeaderHeight = 0.0
        recommendedFilmsTableView.sectionFooterHeight = 0.0
        recommendedFilmsTableView.tableFooterView = UIView(frame:CGRect.zero)
        recommendedFilmsTableView.delegate = self
        recommendedFilmsTableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        movies = []
        presenter?.getRecommendedMovies()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieCell.heightCell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "movieCell")
        }

        movieCell.setCellValues(movieImage: movies[indexPath.row].poster ?? "", movieTitle: movies[indexPath.row].title ?? "", movieYear: movies[indexPath.row].year ?? "")
        
        return movieCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "movieDetailController") as? MovieDetailController else {
            return
        }
        
        movieDetailViewController.imdbID = movies[indexPath.row].imdb ?? "0"
        self.navigationController?.pushViewController(movieDetailViewController, animated: false)
    }

}

extension RecommendedMoviesTableViewController: RecommendedMoviesControllerDelegate {
    func showLoadingView() {
        LoaderManager.showLoader(LoaderManager.loader(loaderType: .indeterminateCircular(.none), inView: self.view, size: CGSize(width: 50, height: 50)))
    }
    
    func removeLoadingView() {
        DispatchQueue.main.async(execute: { [weak self] in
            guard let self = self else { return }
            do {
                LoaderManager.hideLoaderOfView(self.view)
            }
        })
    }
    
    func success(movies: [RecommendedMovie]?) {
        self.movies = []
        self.movies = movies ?? []
        self.recommendedFilmsTableView.reloadData()
    }
    
    func failed(error: String) {
        Utilities.showAlert(vc: self)
    }
    
    
}

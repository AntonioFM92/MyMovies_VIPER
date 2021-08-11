//
//  MovieDetailController.swift
//  MyMovie
//
//  Created by Antonio Fernández Martín on 26/08/2019.
//  Copyright © 2019 Antonio Fernández Martín. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import SDOSLoader

enum FavState {
    case isFavourite
    case notFavourite
}

protocol MovieDetailControllerDelegate {
    
    func initMovieDetail(movieTitle: String, movieImage: String, movieDate: String, movieDuration: String, movieGenre: String, movieWebsite: String, moviePlot: String)
    
    func showLoadingView()
    func removeLoadingView()
    
    func successSearch(movieDetail: MovieDetailDto?)
    func failed(error: String)
    
}

class MovieDetailController: UIViewController {

    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var movieDate: UILabel!
    @IBOutlet var movieDuration: UILabel!
    @IBOutlet var movieGenre: UILabel!
    @IBOutlet var movieWebSite: UITextView!
    @IBOutlet var moviePlot: UITextView!
    @IBOutlet weak var favButton: UIButton!
    
    var movieDetailDto: MovieDetailDto?
    private var presenter: MovieDetailPresenterDelegate?
    var imdbID: String = ""
    
    var originalFrame: CGRect?
    
    var isFavourite: FavState!
    
    //Setup favourite button image
    let context = StorageService.shared.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let play = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        navigationItem.rightBarButtonItems = [play]
        
        presenter = MovieDetailPresenter(ui: self)
        presenter?.showLoadingView()
        presenter?.getMovieDetail(parameters: Utilities.getParametersSearchMovieDetail(movieID: imdbID), body: [:])
        
        originalFrame = movieImage.frame
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        movieImage.addGestureRecognizer(tapGesture)
        
        movieWebSite.delegate = self
        moviePlot.delegate = self
    }
    
    @objc func shareTapped() {
        
        Database.database().reference().child("pelis/\(imdbID)/title").setValue(movieDetailDto?.title)
        Database.database().reference().child("pelis/\(imdbID)/year").setValue(movieDetailDto?.year)
        Database.database().reference().child("pelis/\(imdbID)/poster").setValue(movieDetailDto?.poster)
        
        DispatchQueue.main.async(execute: { [weak self] in
        guard let self = self else { return }
        do {
            let activityViewController = UIActivityViewController(activityItems: [self.movieDetailDto?.title ?? "", self.movieDetailDto?.website ?? ""] , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func toFavourites(_ sender: Any) {
        if self.isFavourite == .isFavourite {
            removeFromFavourites()
        } else {
            addToFavourites()
        }
    }
    
    //Gesture to show image full screen
    @objc func tapped(_ sender: UITapGestureRecognizer? = nil) {
        
        let tapGestureToClose = UITapGestureRecognizer(target: self, action: #selector(self.tappedToClose(_:)))
        movieImage.addGestureRecognizer(tapGestureToClose)
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.bringSubviewToFront(movieImage)
        
        movieImage.frame = UIScreen.main.bounds
        movieImage.backgroundColor = UIColor.black
    }
    
    //Gesture to close image full screen
    @objc func tappedToClose(_ sender: UITapGestureRecognizer? = nil) {
        
        self.navigationController?.isNavigationBarHidden = false
        movieImage.frame = originalFrame!
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        movieImage.addGestureRecognizer(tapGesture)
    }
}

//MARK: - DelegateClass
extension MovieDetailController: MovieDetailControllerDelegate {
    
    func initMovieDetail(movieTitle: String, movieImage: String, movieDate: String, movieDuration: String, movieGenre: String, movieWebsite: String, moviePlot: String){
        self.movieTitle.text = movieTitle
        self.movieDate.text = movieDate
        self.movieDuration.text = movieDuration
        self.movieGenre.text = movieGenre
        
        self.movieWebSite.setAsLink(value: movieWebsite)
        self.movieWebSite.setTappable(value: movieWebsite)
        
        self.moviePlot.text = moviePlot
        
        guard let movieImageURL = URL(string: Utilities.checkImageUrl(imageURL: movieImage)) else {
            return
        }
        self.movieImage.sd_setImage(with: movieImageURL, placeholderImage: UIImage(named: "noposter"))
        self.movieImage.setSaveGesture()
    }
    
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
    
    func successSearch(movieDetail: MovieDetailDto?) {
        guard let movieDetail = movieDetail else {
            return
        }
        self.movieDetailDto = movieDetail
        
        presenter!.removeLoadingView()
        presenter!.initMovieDetail(movieTitle: movieDetail.title ?? "", movieImage: movieDetail.poster ?? "", movieDate: movieDetail.released ?? "", movieDuration: movieDetail.runtime ?? "", movieGenre: movieDetail.genre ?? "", movieWebsite: movieDetail.website ?? "", moviePlot: movieDetail.plot ?? "")
        
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        guard let imdbID = movieDetailDto?.imdbID else {
            updateFavouriteUI(for: .notFavourite)
            return
        }
        let namePredicate = NSPredicate(format: "imdbID == %@", imdbID)
        let isFavPredicate = NSPredicate(format: "isFavourite == %@", NSNumber(booleanLiteral: true))
        let compundPredicate = NSCompoundPredicate(type: .and, subpredicates: [namePredicate, isFavPredicate])
        fetchRequest.predicate = compundPredicate
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 1 {
                updateFavouriteUI(for: .isFavourite)
                self.isFavourite = .isFavourite
            } else {
                self.isFavourite = .notFavourite
            }
        } catch let error {
            print(error)
        }
        
        updateFavouriteUI(for: self.isFavourite)
    }
    
    func failed(error: String) {
        let alert = UIAlertController(title: error, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
        present(alert, animated: true)
    }
    
}

extension MovieDetailController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        view.layoutIfNeeded()
    }
}

extension MovieDetailController {
    
    func addToFavourites() {
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
        guard let imdbID = movieDetailDto?.imdbID else {
            return
        }
        fetchRequest.predicate = NSPredicate(format: "imdbID == %@", imdbID)
        fetchRequest.fetchLimit = 1 // Redundant
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 1 {
                let record = try context.fetch(fetchRequest)
                record.first?.setValue(NSNumber(booleanLiteral: true), forKey: "isFavourite")
                
                StorageService.shared.saveContext()
                
                self.isFavourite = .isFavourite
                updateFavouriteUI(for: .isFavourite)
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: context)!
                let stationRecord = NSManagedObject(entity: entity, insertInto: context)
                
                stationRecord.setValue(self.movieDetailDto?.title, forKey: "title")
                stationRecord.setValue(self.movieDetailDto?.poster, forKey: "poster")
                stationRecord.setValue(self.movieDetailDto?.released, forKey: "released")
                stationRecord.setValue(self.movieDetailDto?.runtime, forKey: "runtime")
                stationRecord.setValue(self.movieDetailDto?.genre, forKey: "genre")
                stationRecord.setValue(self.movieDetailDto?.website, forKey: "website")
                stationRecord.setValue(self.movieDetailDto?.plot, forKey: "plot")
                stationRecord.setValue(self.movieDetailDto?.imdbID, forKey: "imdbID")
                stationRecord.setValue(true, forKey: "isFavourite")
                
                StorageService.shared.saveContext()
                updateFavouriteUI(for: .isFavourite)
                
                self.isFavourite = .isFavourite
            }
            
        } catch let error {
            print(error)
        }
    }
    
    func removeFromFavourites() {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
        guard let imdbID = movieDetailDto?.imdbID else {
            updateFavouriteUI(for: .notFavourite)
            return
        }
        fetchRequest.predicate = NSPredicate(format: "imdbID == %@", imdbID)
        fetchRequest.fetchLimit = 1 // Redundant
        
        do {
            let record = try context.fetch(fetchRequest)
            record.first?.setValue(NSNumber(booleanLiteral: false), forKey: "isFavourite")
            
            StorageService.shared.saveContext()
            
            self.isFavourite = .notFavourite
            updateFavouriteUI(for: .notFavourite)
        } catch let error {
            print(error)
        }
    }
    
    func updateFavouriteUI(for state: FavState) {
        switch state {
        case .isFavourite:
            favButton.setBackgroundImage(UIImage(named: "remove-favourite"), for: .normal)
        default:
            favButton.setBackgroundImage(UIImage(named: "add-favorite"), for: .normal)
        }
    }
}

//
//  FavouritesPresenter.swift
//  MyMovies
//
//  Created by Antonio Fernández Martín on 10/09/2020.
//  Copyright © 2020 Antonio Fernández Martín. All rights reserved.
//

import Foundation
import CoreData

protocol FavouritesPresenterDelegate {
    
    func showLoadingView()
    func removeLoadingView()
    
    func getFavouritesMovies()
}

class FavouritesPresenter: FavouritesPresenterDelegate {
    
    var favouritesController: FavouritesControllerDelegate
    var model: FavouritesModel?
    
    let context = StorageService.shared.persistentContainer.viewContext
    
    init(ui: FavouritesControllerDelegate){
        favouritesController = ui
        model = FavouritesModel(presenter: self)
    }
    
    func showLoadingView(){
        favouritesController.showLoadingView()
    }
    
    func getFavouritesMovies() {
        guard let model = model else {
            return
        }
        
        model.getFavourites(callBacks:{ (isSuccess, movies, error) in
            if isSuccess{
                self.favouritesController.success(movies: movies)
            }else{
                self.favouritesController.failed(error: error!)
            }
        })
    }
    
    func removeLoadingView(){
        favouritesController.removeLoadingView()
    }
    
}

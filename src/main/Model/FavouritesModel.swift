//
//  FavouritesModel.swift
//  MyMovies
//
//  Created by Antonio Fernández Martín on 10/09/2020.
//  Copyright © 2020 Antonio Fernández Martín. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

protocol FavouritesModelDelegate {
    
    typealias callbacks = (_ isSuccessful:Bool,_ success: [MovieEntity],_ fail: String?)->Void
    func getFavourites(callBacks: @escaping callbacks)
    
}

class FavouritesModel: FavouritesModelDelegate {
    
    var favouritesPresenter: FavouritesPresenterDelegate
    let context = StorageService.shared.persistentContainer.viewContext
    
    init(presenter: FavouritesPresenterDelegate){
        favouritesPresenter = presenter
    }
    
    func getFavourites(callBacks: @escaping FavouritesModelDelegate.callbacks) {
        do {
            let favRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
            favRequest.predicate = NSPredicate(format: "isFavourite == %@", NSNumber(value: true))
            
            guard let favourites = try self.context.fetch(favRequest) as? [MovieEntity] else {
                callBacks(false,[],"error")
                return
            }
            callBacks(true, favourites, nil)
        } catch {
            callBacks(false, [], "error")
        }
    }
    
}

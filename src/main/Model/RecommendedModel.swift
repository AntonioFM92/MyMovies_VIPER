//
//  RecommendedModel.swift
//  MyMovies
//
//  Created by Antonio Fernández Martín on 23/09/2020.
//  Copyright © 2020 Antonio Fernández Martín. All rights reserved.
//

import Foundation
import Firebase

protocol RecommendedModelDelegate {
    
    typealias callbacks = (_ isSuccessful:Bool,_ success: [RecommendedMovie],_ fail: String?)->Void
    func getRecommendedMovies(callBacks: @escaping callbacks)
    
}

class RecommendedModel: RecommendedModelDelegate {
    
    var recommendedPresenter: RecommendedMoviesPresenterDelegate
    var recommendedMovies: [RecommendedMovie] = []
    
    init(presenter: RecommendedMoviesPresenterDelegate){
        recommendedPresenter = presenter
    }
    
    func getRecommendedMovies(callBacks: @escaping RecommendedModelDelegate
        .callbacks) {
        
        Database.database().reference().observe(DataEventType.value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let pelis = value?["pelis"] as? NSDictionary
            
            self.recommendedMovies = []
            
            if let pelis = pelis {
                for peli in pelis {
                    let recommendedFilm = RecommendedMovie()
                    recommendedFilm.imdb = peli.key as! String
                    
                    let peliValue = peli.value as? NSDictionary
                    recommendedFilm.year = peliValue?.value(forKey: "year") as? String
                    recommendedFilm.title = peliValue?.value(forKey: "title") as? String
                    recommendedFilm.poster = peliValue?.value(forKey: "poster") as? String
                    
                    self.recommendedMovies.append(recommendedFilm)
                }
            }
            
            callBacks(true, self.recommendedMovies, nil)
          }) { (error) in
            callBacks(false, [], error.localizedDescription)
            print(error.localizedDescription)
        }
    }
    
}

//
//  RecommendedMoviesPresenter.swift
//  MyMovies
//
//  Created by Antonio Fernández Martín on 22/09/2020.
//  Copyright © 2020 Antonio Fernández Martín. All rights reserved.
//

import Foundation

protocol RecommendedMoviesPresenterDelegate {
    func showLoadingView()
    func removeLoadingView()
    
    func getRecommendedMovies()
}

class RecommendedMoviesPresenter: RecommendedMoviesPresenterDelegate {
    
    var recommendedMoviesController: RecommendedMoviesControllerDelegate
    var model: RecommendedModel?
    
    init(ui: RecommendedMoviesControllerDelegate){
        recommendedMoviesController = ui
        model = RecommendedModel(presenter: self)
    }
    
    func showLoadingView(){
        recommendedMoviesController.showLoadingView()
    }
    
    func getRecommendedMovies() {
        
        guard let model = model else {
            return
        }
        showLoadingView()
        model.getRecommendedMovies(callBacks:{ (isSuccess, movies, error) in
            if isSuccess{
                self.removeLoadingView()
                self.recommendedMoviesController.success(movies: movies)
            }else{
                self.removeLoadingView()
                self.recommendedMoviesController.failed(error: error!)
            }
        })
    }
    
    func removeLoadingView(){
        recommendedMoviesController.removeLoadingView()
    }
}

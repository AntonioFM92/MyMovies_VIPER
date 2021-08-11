//
//  MoviesModel.swift
//  MyMovie
//
//  Created by Antonio Fernández Martín on 27/08/2019.
//  Copyright © 2019 Antonio Fernández Martín. All rights reserved.
//

import Foundation
import ObjectMapper

protocol MoviesModelDelegate {
    
    typealias callbacks = (_ isSuccessful:Bool,_ success: MovieDto?,_ fail: String?)->Void
    func getMovies(parameters: [String: String], body: [String: String], callBacks: @escaping callbacks)
    
}

class MoviesModel: MoviesModelDelegate {
    
    var moviePresenter: MoviesPresenterDelegate
    let apiManager: ApiManager!
    
    init(presenter: MoviesPresenterDelegate){
        moviePresenter = presenter
        self.apiManager = ApiManager()
    }
    
    func getMovies(parameters: [String: String], body: [String : String], callBacks: @escaping MoviesModelDelegate.callbacks) {
        apiManager.get(url: Environment.baseUrl, parameters: parameters, apiCallback:{(isSuccessful, JSON, error) in
            if isSuccessful{
                if let moviesJSONResponse = Mapper<MovieDto>().map(JSONObject: JSON){
                    callBacks(true, moviesJSONResponse, nil)
                }else {
                    callBacks(false,nil,error)
                }
            }else {
                callBacks(false,nil,error)
            }
        })
    }
    
}

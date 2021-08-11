//
//  MovieDetailModel.swift
//  MyMovie
//
//  Created by Antonio Fernández Martín on 27/08/2019.
//  Copyright © 2019 Antonio Fernández Martín. All rights reserved.
//

import Foundation
import ObjectMapper

protocol MovieDetailModelDelegate {
    
    typealias callbacks = (_ isSuccessful:Bool,_ success: MovieDetailDto?,_ fail: String?)->Void
    func getMovieDetail(parameters: [String: String], body: [String: String], callBacks: @escaping callbacks)
    
}

class MovieDetailModel: MovieDetailModelDelegate {
    
    var movieDetailPresenter: MovieDetailPresenterDelegate
    let apiManager: ApiManager!
    
    init(presenter: MovieDetailPresenterDelegate){
        movieDetailPresenter = presenter
        self.apiManager = ApiManager()
    }
    
    func getMovieDetail(parameters: [String: String], body: [String : String], callBacks: @escaping MovieDetailModelDelegate.callbacks) {
        apiManager.get(url: Environment.baseUrl, parameters: parameters, apiCallback:{(isSuccessful, JSON, error) in
            if isSuccessful{
                if let movieDetailJSONResponse = Mapper<MovieDetailDto>().map(JSONObject: JSON){
                    callBacks(true, movieDetailJSONResponse, nil)
                }else {
                    callBacks(false,nil,error)
                }
            }else {
                callBacks(false,nil,error)
            }
        })
    }
    
}

//
//  ApiManager.swift
//  MyMovie
//
//  Created by Antonio Fernández Martín on 26/08/2019.
//  Copyright © 2019 Antonio Fernández Martín. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class ApiManager {
    
    typealias ApiCallback = (_ isSuccessful: Bool, _ JSON:Any?, _ fail:String)->Void
    
    func get(url: String, parameters: Parameters, apiCallback: @escaping ApiCallback){
        
        let headers: HTTPHeaders = [ : ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseJSON{ response in
            switch response.result{
                
            case .success(let data) :
                
                switch response.response!.statusCode {
                case (200...300):
                    apiCallback(true,data,"")
                    break
                default:
                    apiCallback(false,nil, NSLocalizedString("networkError2", comment: ""))
                    break
                }
                
            case .failure( _) :
                apiCallback(false,nil, NSLocalizedString("networkError", comment: ""))
                break
                
            }
        }
    }
    
}

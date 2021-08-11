//
//  MovieDto.swift
//  MyMovie
//
//  Created by Antonio Fernández Martín on 26/08/2019.
//  Copyright © 2019 Antonio Fernández Martín. All rights reserved.
//

import Foundation
import ObjectMapper

struct MovieDto : Mappable {
    
    var search: [SearchDto]?
    var totalResults: String?
    var response: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        search <- map["Search"]
        totalResults <- map["totalResults"]
        response <- map["Response"]
    }
    
}

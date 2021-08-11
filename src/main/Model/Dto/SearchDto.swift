//
//  SearchDto.swift
//  MyMovie
//
//  Created by Antonio Fernández Martín on 26/08/2019.
//  Copyright © 2019 Antonio Fernández Martín. All rights reserved.
//

import Foundation
import ObjectMapper

struct SearchDto : Mappable {
    
    var title: String?
    var year: String?
    var imdbID: String?
    var type: String?
    var poster: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        title <- map["Title"]
        year <- map["Year"]
        imdbID <- map["imdbID"]
        type <- map["Type"]
        poster <- map["Poster"]
    }
    
}

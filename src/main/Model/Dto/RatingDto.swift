//
//  RatingDto.swift
//  MyMovie
//
//  Created by Antonio Fernández Martín on 26/08/2019.
//  Copyright © 2019 Antonio Fernández Martín. All rights reserved.
//

import Foundation
import ObjectMapper

struct RatingDto : Mappable {
    
    var source: String?
    var value: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        source <- map["Source"]
        value <- map["Value"]
    }
    
}

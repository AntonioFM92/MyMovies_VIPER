//
//  MovieEntity+CoreDataProperties.swift
//  RadioStation
//
//  Created by Antonio Fernández Martín on 23/05/2020.
//  Copyright © 2020 Antonio Fernández Martín. All rights reserved.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var title: String
    @NSManaged public var year: String
    @NSManaged public var rated: String
    @NSManaged public var released: String
    @NSManaged public var runtime: String
    @NSManaged public var genre: String
    @NSManaged public var director: String
    @NSManaged public var writer: String
    @NSManaged public var actors: String
    @NSManaged public var plot: String
    @NSManaged public var language: String
    @NSManaged public var country: String
    @NSManaged public var awards: String
    @NSManaged public var poster: String
    @NSManaged public var metascore: String
    @NSManaged public var imdbRating: String
    @NSManaged public var imdbVotes: String
    @NSManaged public var imdbID: String
    @NSManaged public var type: String
    @NSManaged public var dVD: String
    @NSManaged public var boxOffice: String
    @NSManaged public var production: String
    @NSManaged public var website: String
    @NSManaged public var response: String

}

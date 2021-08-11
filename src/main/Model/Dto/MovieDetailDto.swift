//
//  MovieDetailDto.swift
//  MyMovie
//
//  Created by Antonio Fernández Martín on 26/08/2019.
//  Copyright © 2019 Antonio Fernández Martín. All rights reserved.
//

import Foundation
import ObjectMapper

struct MovieDetailDto : Mappable, Decodable {
    
    var title: String?
    var year: String?
    var rated: String?
    var released: String?
    var runtime: String?
    var genre: String?
    var director: String?
    var writer: String?
    var actors: String?
    var plot: String?
    var language: String?
    var country: String?
    var awards: String?
    var poster: String?
    //var ratings: [RatingDto]?
    var metascore: String?
    var imdbRating: String?
    var imdbVotes: String?
    var imdbID: String?
    var type: String?
    var dVD: String?
    var boxOffice: String?
    var production: String?
    var website: String?
    var response: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        title <- map["Title"]
        year <- map["Year"]
        rated <- map["Rated"]
        released <- map["Released"]
        runtime <- map["Runtime"]
        genre <- map["Genre"]
        director <- map["Director"]
        writer <- map["Writer"]
        actors <- map["Actors"]
        plot <- map["Plot"]
        language <- map["Language"]
        country <- map["Country"]
        awards <- map["Awards"]
        poster <- map["Poster"]
        //ratings <- map["Ratings"]
        metascore <- map["Metascore"]
        imdbRating <- map["imdbRating"]
        imdbVotes <- map["imdbVotes"]
        imdbID <- map["imdbID"]
        type <- map["Type"]
        dVD <- map["DVD"]
        boxOffice <- map["BoxOffice"]
        production <- map["Production"]
        website <- map["Website"]
        response <- map["Response"]
    }
    
    init(from movieEntity: MovieEntity) {
        self.title = movieEntity.title
        self.year = movieEntity.year
        self.rated = movieEntity.rated
        self.released = movieEntity.released
        self.runtime = movieEntity.runtime
        self.genre = movieEntity.genre
        self.director = movieEntity.director
        self.writer = movieEntity.writer
        self.actors = movieEntity.actors
        self.plot = movieEntity.plot
        self.language = movieEntity.language
        self.country = movieEntity.country
        self.awards = movieEntity.awards
        self.poster = movieEntity.poster
        self.metascore = movieEntity.metascore
        self.imdbRating = movieEntity.imdbRating
        self.imdbVotes = movieEntity.imdbVotes
        self.imdbID = movieEntity.imdbID
        self.type = movieEntity.type
        self.dVD = movieEntity.dVD
        self.boxOffice = movieEntity.boxOffice
        self.production = movieEntity.production
        self.website = movieEntity.website
        self.response = movieEntity.response
    }
}

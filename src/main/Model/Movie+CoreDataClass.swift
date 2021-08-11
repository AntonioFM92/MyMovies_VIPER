//
//  MovieEntity+CoreDataClass.swift
//  RadioStation
//
//  Created by Antonio Fernández Martín on 23/05/2020.
//  Copyright © 2020 Antonio Fernández Martín. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MovieEntity)
public class MovieEntity: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case title
        case year
        case imdbID
        case poster
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(year, forKey: .year)
        try container.encode(imdbID, forKey: .imdbID)
        try container.encode(poster, forKey: .poster)
    }


    public required convenience init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Subject", in: managedObjectContext) else {  fatalError("Failed to decode Subject!")  }

        self.init(entity: entity, insertInto: nil)

        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        year = try values.decode(String.self, forKey: .year)
        imdbID = try values.decode(String.self, forKey: .imdbID)
        poster = try values.decode(String.self, forKey: .poster)
    }
    
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

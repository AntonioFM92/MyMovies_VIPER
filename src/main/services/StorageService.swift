//
//  StorageService.swift
//  MyMovies
//
//  Created by Antonio Fernández Martín on 08/09/2020.
//  Copyright © 2020 Antonio Fernández Martín. All rights reserved.
//

import UIKit
import CoreData
import SDOSPluggableApplicationDelegate

/// The service for _Repository_.
final class StorageService: NSObject, ApplicationService, SceneService {
    
    // MARK: ⚑ Public parameters
    
    /// The shared instance.
    static let shared = StorageService()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Movie")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return container
    }()
    
    // MARK: ⚑ Init
    
    private override init() { }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError? {
                fatalError("Unresolved error: \(String(describing: error))")
            }
        }
    }
    
    //MARK: - Private methods
    
}

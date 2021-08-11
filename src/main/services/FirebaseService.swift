//
//  FirebaseService.swift
//  MyMovies
//
//  Created by Antonio Fernández Martín on 22/09/2020.
//  Copyright © 2020 Antonio Fernández Martín. All rights reserved.
//

import UIKit
import Firebase
import SDOSPluggableApplicationDelegate

/// The service for _Repository_.
final class FirebaseService: NSObject, ApplicationService, SceneService {
    
    // MARK: ⚑ Public parameters
    
    /// The shared instance.
    static let shared = FirebaseService()
    
    // MARK: ⚑ Init
    
    private override init() { }
    
    //MARK: - Private methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
}

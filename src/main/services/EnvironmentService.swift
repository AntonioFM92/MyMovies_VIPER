//
//  EnvironmentService.swift
//  MyMovies
//
//  Created by Antonio Fernández Martín on 23/08/2020.
//  Copyright © 2020 Antonio Fernández Martín. All rights reserved.
//

import Foundation
import SDOSPluggableApplicationDelegate
import SDOSEnvironment

// MARK: - ⚑ Class EnviromentService

/// The service for Enviroment.
final class EnvironmentService: NSObject, ApplicationService {
    
    // MARK: ⚑ Public parameters
    
    /// The shared instance.
    static let shared = EnvironmentService()
    
    // MARK: ⚑ Init
    
    private override init() { }
    
    // MARK: ⚑ Implementation ApplicationService
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        do {
            self.configure()
            
            return true
        }
    }
    
    // MARK: ⚑ Private methods

    /**
     Configure.
     */
    private func configure() {
        if let encryptPassword = getEncryptPassword() {
            SDOSEnvironment.configure(password: encryptPassword, activeLogging: true)
        }
    }
    
    private func getEncryptPassword() -> String? {
        if let encryptPassword = Bundle(for: EnvironmentService.self).object(forInfoDictionaryKey: "EncryptPassword") as? String {
            return encryptPassword
        }
        return nil
    }
}

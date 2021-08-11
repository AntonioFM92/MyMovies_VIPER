//
//  AppDelegate.swift
//  MyMovie
//
//  Created by Antonio Fernández Martín on 26/08/2019.
//  Copyright © 2019 Antonio Fernández Martín. All rights reserved.
//

import UIKit
import SDOSPluggableApplicationDelegate

// MARK: - ⚑ Class AppDelegate

@UIApplicationMain
class AppDelegate: PluggableApplicationDelegate {
    
    // MARK: ⚑ Implementation PluggableApplicationDelegate
    
    override var applicationServices: [ApplicationService] {
        return [
            EnvironmentService.shared,
            RootViewService.shared,
            StorageService.shared,
            FirebaseService.shared
        ]
    }
}


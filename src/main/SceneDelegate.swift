//
//  SceneDelegate.swift
//  MyMovies
//
//  Created by Antonio Fernández Martín on 23/08/2020.
//  Copyright © 2020 Antonio Fernández Martín. All rights reserved.
//

import Foundation
import SDOSPluggableApplicationDelegate

// MARK: - ⚑ Class SceneDelegate

@available(iOS 13.0, *)
class SceneDelegate: PluggableSceneDelegate {
    
    // MARK: ⚑ Implementation PluggableSceneDelegate
    
    override var sceneServices: [SceneService] {
        return [
            RootViewService.shared
        ]
    }
}

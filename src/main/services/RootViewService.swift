//
//  RootViewService.swift
//  MyMovies
//
//  Created by Antonio Fernández Martín on 24/08/2020.
//  Copyright © 2020 Antonio Fernández Martín. All rights reserved.
//

import SDOSPluggableApplicationDelegate

// MARK: - ⚑ Class RepositoryService

/// The service for _Repository_.
final class RootViewService: NSObject, ApplicationService, SceneService {
    
    // MARK: ⚑ Public parameters
    
    /// The shared instance.
    static let shared = RootViewService()
    
    static var window: UIWindow?
    
    // MARK: ⚑ Init
    
    private override init() { }

    // MARK: ⚑ Implementation ApplicationService
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if #available(iOS 13.0, *) {} else {
            RootViewService.loadViewController(window: UIWindow(frame: UIScreen.main.bounds))
        }
        return true
    }
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            RootViewService.loadViewController(window: UIWindow(windowScene: windowScene))
        }
    }
    
    //MARK: - Private methods
    
    static func loadViewController(window: UIWindow) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window.rootViewController = storyboard
        
        window.makeKeyAndVisible()
        self.window = window
    }
}

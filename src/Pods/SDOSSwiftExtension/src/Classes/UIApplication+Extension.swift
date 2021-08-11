//
//  GenericTypes.swift
//  SDOSSwiftExtensionSample
//
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import UIKit

/// Métodos de útilidad para extender la funcionaldad de UIApplication
public extension UIApplication {
    
    /// Devuelve la versión actual de la aplicación
    static var version: String? {
        var result: String?
        if let dicitonary = Bundle.main.infoDictionary {
            result = dicitonary["CFBundleShortVersionString"] as? String
        }
        return result
    }
}

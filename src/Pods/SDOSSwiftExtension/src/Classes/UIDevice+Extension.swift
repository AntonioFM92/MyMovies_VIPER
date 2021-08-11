//
//  GenericTypes.swift
//  SDOSSwiftExtensionSample
//
//  Copyright © 2019 SDOS. All rights reserved.
//

import Foundation
import UIKit

/// Métodos de útilidad para extender la funcionaldad de UIDevice
public extension UIDevice {
    
    /// Devuelve información referente al dispositivo en formato model||name||version (Ejemplo simulador: x86_64||iOS||12.2)
    var deviceInformation: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        return "\(modelCode ?? "")||\(self.systemName)||\(self.systemVersion)"
    }
}

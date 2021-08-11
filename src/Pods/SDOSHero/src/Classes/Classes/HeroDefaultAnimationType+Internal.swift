//
//  HeroDefaultAnimationType+Internal.swift
//
//  Copyright © 2018 SDOS. All rights reserved.
//

import Hero

internal extension HeroDefaultAnimationType {
    
    var heroDefaultAnimationTypeForPresenting: HeroDefaultAnimationType {
        if case HeroDefaultAnimationType.selectBy(presenting: let presenting, dismissing: let _) = self {
            return presenting
        } else {
            return self
        }
    }
    
    var heroDefaultAnimationTypeForDismissing: HeroDefaultAnimationType {
        if case HeroDefaultAnimationType.selectBy(presenting: let _, dismissing: let dismissing) = self {
            return dismissing
        } else {
            return self
        }
    }
    
}

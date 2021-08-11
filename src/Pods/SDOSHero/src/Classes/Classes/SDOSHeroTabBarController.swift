//
//  SDOSHeroTabBarController.swift
//
//  Copyright © 2018 SDOS. All rights reserved.
//

import Hero

open class SDOSHeroTabBarController: UITabBarController {
    
    
    /// Method used to set the Hero animation type for the item selections of the tab bar. For visual consistency, the passed animation `type` will be used when the target item index is bigger than the current index. Otherwise, the opposite animation will be used.
    ///
    /// - Parameter type: The type of the transition animation for the tab bar item selection.
    public func setTabBarAnimationType(_ type: HeroDefaultAnimationType) {
        hero.tabBarAnimationType = type
        currentTabBarAnimationTypeIsReversed = false
    }
    
    private var currentTabBarAnimationTypeIsReversed: Bool = false
    
    override open func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let items = tabBar.items,
            let nextIndex = items.index(of: item) {
            let currentIndex = selectedIndex
            
            guard currentIndex != nextIndex else {
                // This prevents a bug where if different buttons of the tabBar are tapped very quickly, then currentIndex and nextIndex are equal and this could make currentTabBarAnimationTypeIsReversed change without the heroTabBarAnimationType changing
                return
            }
            
            configureAnimationForTransition(fromIndex: currentIndex, toIndex: nextIndex)
            
            // Necessary to avoid a crash of Hero when tapping the tabBar very quickly
            tabBar.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.35, execute: {
                tabBar.isUserInteractionEnabled = true
            })
        }
    }
    
    
    open override var selectedIndex: Int {
        willSet {
            configureAnimationForTransition(fromIndex: selectedIndex, toIndex: newValue)
        }
    }
    
    open override var selectedViewController: UIViewController? {
        willSet {
            guard
                let vc = newValue,
                let newIndex = viewControllers?.firstIndex(of: vc)
                else {
                    return
            }
            configureAnimationForTransition(fromIndex: selectedIndex, toIndex: newIndex)
        }
    }
    
    private func configureAnimationForTransition(fromIndex: Int, toIndex: Int) {
        if (toIndex < fromIndex && !currentTabBarAnimationTypeIsReversed) || (toIndex > fromIndex && currentTabBarAnimationTypeIsReversed) {
            heroTabBarAnimationType = heroTabBarAnimationType.oppositeAnimationType
        }
        currentTabBarAnimationTypeIsReversed = toIndex < fromIndex
    }
    
}

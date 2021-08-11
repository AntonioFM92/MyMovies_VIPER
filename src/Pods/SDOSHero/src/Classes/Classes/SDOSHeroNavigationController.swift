//
//  SDOSHeroNavigationController.swift
//
//  Copyright © 2018 SDOS. All rights reserved.
//

import UIKit
import Hero

open class SDOSHeroNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    private var arrayHeroAnimationNavigationHistory = [HeroDefaultAnimationType]()
    private lazy var heroTransition: HeroTransition = {
        let heroTransition = HeroTransition.init()
//        self.transitioningDelegate = heroTransition // This must not be done because it would override the modal presentation animation types
        self.delegate = heroTransition
        return heroTransition
    }()
    
    private var desiredNavigationHeroDefaultAnimationType: HeroDefaultAnimationType = .auto
    
    //MARK: - Getting/Setting the animation types
    
    /// The current animation type of the receiver for push transitions.
    ///
    /// If its value is `.auto`, then the animation for push transitions will be the opposite animation to that returned by `animationTypeForPop`.
    /// If the value of `animationTypeForPop` is also `.auto`, then the animation for navigation transitions will be the default system animation.
    public var animationTypeForPush: HeroDefaultAnimationType {
        get {
            return desiredNavigationHeroDefaultAnimationType.heroDefaultAnimationTypeForPresenting
        }
        set {
            switch desiredNavigationHeroDefaultAnimationType {
            case .selectBy(presenting: _, dismissing: let currentDesiredPopType):
                desiredNavigationHeroDefaultAnimationType = .selectBy(presenting: newValue, dismissing: currentDesiredPopType)
            default:
                desiredNavigationHeroDefaultAnimationType = .selectBy(presenting: newValue, dismissing: .auto)
            }
        }
    }
    
    /// The current animation type of the receiver for pop transitions.
    ///
    /// If its value is `.auto`, then the animation for pop transitions will be the opposite animation to that returned by `animationTypeForPush`.
    /// If the value of `animationTypeForPush` is also `.auto`, then the animation for navigation transitions will be the default system animation.
    public var animationTypeForPop: HeroDefaultAnimationType {
        get {
            return desiredNavigationHeroDefaultAnimationType.heroDefaultAnimationTypeForDismissing
        }
        set {
            switch desiredNavigationHeroDefaultAnimationType {
            case .selectBy(presenting: let currentDesiredPushType, dismissing: _):
                desiredNavigationHeroDefaultAnimationType = .selectBy(presenting: currentDesiredPushType, dismissing: newValue)
            default:
                desiredNavigationHeroDefaultAnimationType = .selectBy(presenting: .auto, dismissing: newValue)
            }
        }
    }
    
    
    /// Method used to set the default animation type for push and pop transitions.
    ///
    /// This method is equivalent to setting `animationTypeForPush` to `pushType` and `animationTypeForPop` to `popType`.
    ///
    /// - Parameter pushType: The type of the animation for push transitions.
    /// - Parameter popType: The type of the animation for pop transitions.
    public func setHeroAnimationTypeForPushNavigations(_ pushType: HeroDefaultAnimationType, forPopNavigations popType: HeroDefaultAnimationType) {
        desiredNavigationHeroDefaultAnimationType = .selectBy(presenting: pushType.heroDefaultAnimationTypeForPresenting, dismissing: popType.heroDefaultAnimationTypeForDismissing)
    }
    
    
    /// For internal use. Used in the push and pop methods in case the default animation needs to be change for that transition
    fileprivate var heroAnimationForNextNavigationTransition: HeroDefaultAnimationType?
    
    
    //MARK: - Push
    
    /// Pushes a view controller onto the receiver’s stack using and updates the display.
    /// It animates the transition with the passed animation type.
    ///
    /// The object in the viewController parameter becomes the top view controller on the navigation stack.
    /// Pushing a view controller causes its view to be embedded in the navigation interface.
    ///
    /// The push transition is animated with `pushAnimation`. The transition for the corresponding pop will be animated using the value of `animationTypeForPop` at the moment of the push.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to push onto the stack. This object cannot be a tab bar controller. If the view controller is already on the navigation stack, this method throws an exception.
    ///   - pushAnimation: The animation type for the push transition.
    public func pushViewController(_ viewController: UIViewController, usingAnimation pushAnimation: HeroDefaultAnimationType) {
        pushViewController(viewController, usingPushAnimation: pushAnimation.heroDefaultAnimationTypeForPresenting, popAnimation: desiredNavigationHeroDefaultAnimationType.heroDefaultAnimationTypeForDismissing)
    }
    
    
    /// Pushes a view controller onto the receiver’s stack using and updates the display.
    /// It animates the transition with the passed animation type.
    ///
    /// The object in the viewController parameter becomes the top view controller on the navigation stack.
    /// Pushing a view controller causes its view to be embedded in the navigation interface.
    ///
    /// The push transition is animated with `pushAnimation`. The transition for the corresponding pop will be animated using the opposite animation type to `pushAnimation`.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to push onto the stack. This object cannot be a tab bar controller. If the view controller is already on the navigation stack, this method throws an exception.
    ///   - pushAnimation: The animation type for the push transition.
    public func pushViewController(_ viewController: UIViewController, usingAnimationForPushAndOppositeForPop pushAnimation: HeroDefaultAnimationType) {
        let finalPushAnimation = pushAnimation.heroDefaultAnimationTypeForPresenting
        pushViewController(viewController, usingPushAnimation: finalPushAnimation, popAnimation: finalPushAnimation.oppositeAnimationType)
    }
    
    
    /// Pushes a view controller onto the receiver’s stack using and updates the display.
    /// It animates the transition with the passed animation type.
    ///
    /// The object in the viewController parameter becomes the top view controller on the navigation stack.
    /// Pushing a view controller causes its view to be embedded in the navigation interface.
    ///
    /// The push transition is animated with `pushAnimation`. The transition for the corresponding pop will be animated with `popAnimation`.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to push onto the stack. This object cannot be a tab bar controller. If the view controller is already on the navigation stack, this method throws an exception.
    ///   - pushAnimation: The animation type for the push transition.
    ///   - popAnimation: The animation type for the corresponding pop transition.
    public func pushViewController(_ viewController: UIViewController, usingPushAnimation pushAnimation: HeroDefaultAnimationType, popAnimation: HeroDefaultAnimationType) {
        heroAnimationForNextNavigationTransition = HeroDefaultAnimationType.selectBy(presenting: pushAnimation.heroDefaultAnimationTypeForPresenting, dismissing: popAnimation.heroDefaultAnimationTypeForDismissing)
        pushViewController(viewController, animated: true)
    }
    
    private var viewControllersHashes = [Int]()
    
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllersHashes.contains(viewController.hash) {
            super.pushViewController(viewController, animated: animated)
        } else {
            viewControllersHashes.append(viewController.hash)
            
            let animationType = finalAnimationForNextPush()
            arrayHeroAnimationNavigationHistory.append(animationType)
    
            hero.navigationAnimationType = animationType
            
            super.pushViewController(viewController, animated: animated)
            
            updateInteractivePopGestureRecognizer()
            
            // Disable the interactions during the push animation
            customInteractivePopGestureRecognizer?.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.351) {
                self.customInteractivePopGestureRecognizer?.isEnabled = true
            }
        }
    }
    
    
    private func finalAnimationForNextPush() -> HeroDefaultAnimationType {
        var animationType: HeroDefaultAnimationType
        if let type = heroAnimationForNextNavigationTransition {
            heroAnimationForNextNavigationTransition = nil
            animationType = type
        } else {
            animationType = desiredNavigationHeroDefaultAnimationType
        }
        
        return parse(animationType: animationType)
    }
    
    
    /// This function takes care of normalizing the animation for presentation and dismissal. That is to make sure that if the animation for only one transition (presentation or dismissal) is set to .auto, it changes it to the opposite of the animation for the other transition.
    ///
    /// - Parameter type: the animation type to be normalized
    /// - Returns: the normalized animation type
    private func parse(animationType type: HeroDefaultAnimationType) -> HeroDefaultAnimationType {
        let parsedAnimationType: HeroDefaultAnimationType
        switch type {
        case .selectBy(presenting: .auto, dismissing: .auto):
            parsedAnimationType = .auto
        case .selectBy(presenting: let presenting, dismissing: .auto):
            parsedAnimationType = .selectBy(presenting: presenting, dismissing: presenting.oppositeAnimationType)
        case .selectBy(presenting: .auto, dismissing: let dismissing):
            parsedAnimationType = .selectBy(presenting: dismissing.oppositeAnimationType, dismissing: dismissing)
        default:
            parsedAnimationType = type
        }
        return parsedAnimationType
    }
    
    
    //MARK: Pop
    
    /// Pops the top view controller from the navigation stack and updates the display.
    ///
    /// This method removes the top view controller from the stack and makes the new top of the stack the active view controller.
    /// If the view controller at the top of the stack is the root view controller, this method does nothing.
    /// In other words, you cannot pop the last item on the stack.
    /// - Parameter popAnimation: The animation type for the pop transition.
    /// - Returns: The view controller that was popped from the stack.
    public func popViewControllerUsingAnimation(_ popAnimation: HeroDefaultAnimationType) -> UIViewController? {
        heroAnimationForNextNavigationTransition = HeroDefaultAnimationType.selectBy(presenting: .auto, dismissing: popAnimation.heroDefaultAnimationTypeForDismissing)
        return popViewController(animated: true)
    }
    
    
    open override func popViewController(animated: Bool) -> UIViewController? {
        
        let animationType = finalAnimationForNextPopTransition(historyAnimationType: arrayHeroAnimationNavigationHistory.popLast())
        hero.navigationAnimationType = animationType
        
        let vc = super.popViewController(animated: animated)
        cleanTrackOf(viewController: vc)
        return vc
    }
    
    
    /// Pops view controllers until the specified view controller is at the top of the navigation stack and using the passed animation for the transition.
    ///
    /// - Parameters:
    ///   - viewController: The view controller that you want to be at the top of the stack. This view controller must currently be on the navigation stack.
    ///   - animation: The animation type for the pop transition.
    /// - Returns: An array containing the view controllers that were popped from the stack.
    public func popToViewController(_ viewController: UIViewController, usingAnimation animation: HeroDefaultAnimationType) -> [UIViewController]? {
        heroAnimationForNextNavigationTransition = HeroDefaultAnimationType.selectBy(presenting: .auto, dismissing: animation.heroDefaultAnimationTypeForDismissing)
        return popToViewController(viewController, animated: true)
    }
    
    
    open override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        
        if let index = viewControllers.index(of: viewController) {
            
            var animationTypeInHistory: HeroDefaultAnimationType? = nil
            
            // In some cases where a lot of pushes and pops are invoked, a crash could happen due to an "Array index is out of range" error.
            if index < arrayHeroAnimationNavigationHistory.count {
                animationTypeInHistory = arrayHeroAnimationNavigationHistory.popLast()
                arrayHeroAnimationNavigationHistory = Array(arrayHeroAnimationNavigationHistory[0..<index])
            }
            
            let animationType = finalAnimationForNextPopTransition(historyAnimationType: animationTypeInHistory)
            hero.navigationAnimationType = animationType
            
            updateInteractivePopGestureRecognizer()
        } else {
            heroAnimationForNextNavigationTransition = nil
        }
        
        let arrayVCs = super.popToViewController(viewController, animated: animated)
        arrayVCs?.forEach {
            cleanTrackOf(viewController: $0)
        }
        return arrayVCs
    }
    
    
    /// Pops all the view controllers on the stack except the root view controller and updates the display. It animates the transition using the passed animation type.
    ///
    /// The root view controller becomes the top view controller.
    ///
    /// - Parameter animation: The animation type for the pop transition.
    /// - Returns: An array of view controllers representing the items that were popped from the stack.
    public func popToRootViewController(usingAnimation animation: HeroDefaultAnimationType) -> [UIViewController]? {
        heroAnimationForNextNavigationTransition = animation.heroDefaultAnimationTypeForDismissing
        return popToRootViewController(animated: true)
    }
    
    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
     
        let animationTypeInHistory = arrayHeroAnimationNavigationHistory.last
        arrayHeroAnimationNavigationHistory.removeAll()
        
        let animationType = finalAnimationForNextPopTransition(historyAnimationType: animationTypeInHistory)
        updateInteractivePopGestureRecognizer()
        hero.navigationAnimationType = animationType
        
        let arrayVC = super.popToRootViewController(animated: animated)
        arrayVC?.forEach {
            cleanTrackOf(viewController: $0)
        }
        return arrayVC
    }
    
    
    //MARK: - Set view controllers
    
    /// Replaces the view controllers currently managed by the navigation controller with the specified items.
    ///
    /// Use this method to update or replace the current view controller stack without pushing or popping each controller explicitly.
    ///
    /// - Parameters:
    ///   - viewControllers: The view controllers to place in the stack. The front-to-back order of the controllers in this array represents the new bottom-to-top order of the controllers in the navigation stack. Thus, the last item added to the array becomes the top item of the navigation stack.
    ///   - animation: The animation type for the transition.
    public func setViewControllers(_ viewControllers: [UIViewController], usingAnimation animation: HeroDefaultAnimationType) {
        hero.navigationAnimationType = animation
        setViewControllers(viewControllers, animated: true)
    }
    
    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if animated {
            hero.navigationAnimationType = desiredNavigationHeroDefaultAnimationType.heroDefaultAnimationTypeForPresenting
        }
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    
    
    
    //MARK: - Helper
    
    private func cleanTrackOf(viewController: UIViewController?) {
        if let hash = viewController?.hash, let index = viewControllersHashes.index(of: hash) {
            viewControllersHashes.remove(at: index)
        }
    }
    
    
    private func finalAnimationForNextPopTransition(historyAnimationType: HeroDefaultAnimationType?) -> HeroDefaultAnimationType {
        let animationType: HeroDefaultAnimationType
        if let type = heroAnimationForNextNavigationTransition {
            heroAnimationForNextNavigationTransition = nil
            animationType = type
        } else {
            animationType = historyAnimationType ?? desiredNavigationHeroDefaultAnimationType
        }
        return parse(animationType: animationType)
    }
    
    
    //MARK: - UIGestureRecognizerDelegate
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            return true
        }
        
        if super.responds(to: #selector(gestureRecognizerShouldBegin(_:))) {
            return super.perform(#selector(gestureRecognizerShouldBegin(_:)), with:gestureRecognizer) as! Bool
        }
        return false
    }
    
    
    //MARK: - Interactive Transition
    
    private var supportsInteractiveTransition: Bool = true {
        didSet {
            updateInteractivePopGestureRecognizer()
        }
    }
    
    
    private func updateInteractivePopGestureRecognizer() {
        
        guard animationTypeForCurrentPop == nil else {
            // Nothing to do here yet, because an animation (due to user touches) is taking place
            return
        }
        
        if supportsInteractiveTransition && arrayHeroAnimationNavigationHistory.count > 0 {
            
            let edges: UIRectEdge = arrayHeroAnimationNavigationHistory.last!.edgeForPanGesture
            if customInteractivePopGestureRecognizer == nil || customInteractivePopGestureRecognizer!.edges != edges {
                let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
                // In order for the gesture to be recognized when edges == .top or .bottom, it is necessary for the ViewController's prefersStatusBarHidden method to return true
                edgePanGesture.edges = edges
                customInteractivePopGestureRecognizer = edgePanGesture
            }
        } else {
            customInteractivePopGestureRecognizer = nil
        }
    }
    
    
    private var customInteractivePopGestureRecognizer: UIScreenEdgePanGestureRecognizer? {
        didSet {
            if oldValue != nil {
                view.removeGestureRecognizer(oldValue!)
            }
            if customInteractivePopGestureRecognizer != nil {
                view.addGestureRecognizer(customInteractivePopGestureRecognizer!)
            }
        }
    }
    

    override open var interactivePopGestureRecognizer: UIGestureRecognizer? {
        get {
            return customInteractivePopGestureRecognizer
        }
    }
    
    
    private var animationTypeForCurrentPop: HeroDefaultAnimationType?
    private var hashForCurrentPop: Int?
    
    @objc func handlePan(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        var progress = abs(gestureRecognizer.translation(in: self.view).x / self.view.bounds.width)
        progress = min(1.0, max(0.0, progress))
        
        switch gestureRecognizer.state {
        case .began:
            // Since in popViewController(animated:) we drop the last element of arrayHeroAnimationNavigationHistory. We need to temporaly store it in order to be able to put the animation back to arrayHeroAnimationNavigationHistory in case the pop is cancelled after all.
            animationTypeForCurrentPop = arrayHeroAnimationNavigationHistory.last
            hashForCurrentPop = viewControllersHashes.last
            
            // begin the transition as normal
            heroTransition.start()
            popViewController(animated: true)
            if let _ = self.delegate as? HeroTransition {
                heroTransition.update(progress)
            }
        case .changed:
            if let _ = self.delegate as? HeroTransition {
                heroTransition.update(progress)
            }
        case .cancelled:
            if let _ = self.delegate as? HeroTransition {
                cancelPop()
            }
        case .failed:
            if let _ = self.delegate as? HeroTransition {
                cancelPop()
            }
        case .ended:
            if let _ = self.delegate as? HeroTransition {
                
                if progress + gestureRecognizer.relativeVelocity > 0.5 {
                    // This "hack" (Dispatch) is needed in order to avoid a crash. This crash could happen if the panning is quickly released after it is started.
                    // See: https://github.com/lkzhao/Hero/issues/203
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                        self.endPop()
                    })
                } else {
                    cancelPop()
                }
            }
        default:
            if let _ = self.delegate as? HeroTransition{
                if progress > 0.5 {
                    endPop()
                } else {
                    cancelPop()
                }
            }
        }
    }
    
    
    private func cancelPop() {
        if let animationTypeForCurrentPop = animationTypeForCurrentPop {
            arrayHeroAnimationNavigationHistory.append(animationTypeForCurrentPop)
            self.animationTypeForCurrentPop = nil
        }
        if let hashForCurrentPop = hashForCurrentPop {
            viewControllersHashes.append(hashForCurrentPop)
            self.hashForCurrentPop = nil
        }
        heroTransition.cancel(animate: true)
        updateInteractivePopGestureRecognizer()
    }
    
    
    private func endPop() {
        animationTypeForCurrentPop = nil
        heroTransition.finish(animate: true)
        updateInteractivePopGestureRecognizer()
    }
}


fileprivate extension UIScreenEdgePanGestureRecognizer {
    var relativeVelocity: CGFloat {
        guard let view = view else {
            return 0
        }
        switch self.edges {
        case UIRectEdge.left:
            return velocity(in: nil).x / view.frame.size.width
        case UIRectEdge.right:
            return -velocity(in: nil).x / view.frame.size.width
        case UIRectEdge.top:
            return velocity(in: nil).y / view.frame.size.height
        case UIRectEdge.bottom:
            return -velocity(in: nil).y / view.frame.size.height
        default:
            return velocity(in: nil).x / view.frame.size.width
        }
    }
}


fileprivate extension HeroDefaultAnimationType {
    var edgeForPanGesture: UIRectEdge {
        switch self {
        case .push(let direction), .pull(let direction), .cover(let direction), .slide(let direction), .zoomSlide(let direction), .pageIn(let direction), .pageOut(let direction):
            switch direction {
            case .left:
                return .left
            case .right:
                return .right
            case .up:
                return .top
            case .down:
                return .bottom
            }
        case .selectBy(presenting: let presenting, dismissing: let _):
            return presenting.edgeForPanGesture
        default:
            return .left
        }
    }
}

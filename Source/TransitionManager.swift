//
//  TransitionManager.swift
//  NiceActionSheet
//
//  Created by David Collado Sela on 22/5/15.
//  Copyright (c) 2015 David Collado Sela. All rights reserved.
//

import UIKit

class TransitionManager: NSObject,UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private var presenting = false
    var screens : (from:UIViewController, to:UIViewController)!
    var transitionContext:UIViewControllerContextTransitioning!
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // animate a change from one viewcontroller to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView()
        
        // create a tuple of our screens
        screens = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        // assign references to our menu view controller and the 'bottom' view controller from the tuple
        // remember that our menuViewController will alternate between the from and to view controller depending if we're presenting or dismissing
        let menuViewController = !self.presenting ? screens.from as! NiceActionSheet : screens.to as! NiceActionSheet
        
        // perform the animation!
        
        if (self.presenting){
            self.onStageMenuController(menuViewController)
        }
        else {
            self.offStageMenuController(menuViewController)
        }
    }
    
    func offStageMenuController(menuViewController:NiceActionSheet){
        menuViewController.viewContainer.layer.removeAllAnimations()
        
        menuViewController.view.backgroundColor = menuViewController.backgroundViewColor.colorWithAlphaComponent(menuViewController.backgroundViewAlpha)
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { () -> Void in
            menuViewController.view.backgroundColor = menuViewController.backgroundViewColor.colorWithAlphaComponent(0)
        })
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.duration = self.transitionDuration(transitionContext)
        animation.fromValue = UIScreen.mainScreen().bounds.height - menuViewController.viewContainer.bounds.height * 0.5
        animation.toValue = UIScreen.mainScreen().bounds.height + menuViewController.viewContainer.bounds.height * 0.5
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.delegate = self
        menuViewController.viewContainer.layer.addAnimation(animation, forKey: "hide")
    }
    
    func onStageMenuController(menuViewController:NiceActionSheet){
        menuViewController.view.backgroundColor = menuViewController.backgroundViewColor.colorWithAlphaComponent(0)
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { () -> Void in
            menuViewController.view.backgroundColor = menuViewController.backgroundViewColor.colorWithAlphaComponent(menuViewController.backgroundViewAlpha)
        })
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.duration = self.transitionDuration(transitionContext)
        animation.fromValue = UIScreen.mainScreen().bounds.height + menuViewController.viewContainer.bounds.height * 0.5
        animation.toValue = UIScreen.mainScreen().bounds.height - menuViewController.viewContainer.bounds.height * 0.5
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.delegate = self
        menuViewController.viewContainer.layer.addAnimation(animation, forKey: "show")
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.2
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animator when presenting a viewcontroller
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        transitionContext.completeTransition(true)
        // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
        UIApplication.sharedApplication().keyWindow?.addSubview(screens.to.view)
    }
    
}



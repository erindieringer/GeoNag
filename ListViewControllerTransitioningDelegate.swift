//
//  ListViewControllerTransitioningDelegate.swift
//  GeoNag
//
//  Created by Katie Williams on 12/13/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit

extension ListViewController: UIViewControllerTransitioningDelegate {
    
    // Functions to control menu animations and how they are presented and dismissed
    
    // MARK: - Present MapMenu Controller Animation
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    // MARK: - Dismiss MapMenu Controller Animation
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    // MARK: - Dismiss Interaction Controller Animation
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    // MARK: - Present Interaction Controller Animation
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

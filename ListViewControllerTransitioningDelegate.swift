//
//  ListViewControllerTransitioningDelegate.swift
//  GeoNag
//
//  Created by Katie Williams on 12/13/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit

extension ListViewController: UIViewControllerTransitioningDelegate {
    
    // MARK: - Functions to control menu animations and how they are presented and dismissed
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

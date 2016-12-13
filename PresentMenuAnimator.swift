//
//  PresentMenuAnimator.swift
//  iOSApp
//
//  Created by Katie Williams on 12/7/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//  Followed tutorial here: http://www.thorntech.com/2016/03/ios-tutorial-make-interactive-slide-menu-swift/
//

import UIKit

class PresentMenuAnimator : NSObject {
}

extension PresentMenuAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let containerView = transitionContext.containerView()
            else {
                return
        }
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        // replace main view with snapshot
        let snapshot = fromVC.view.snapshotViewAfterScreenUpdates(false)
        snapshot.tag = MenuHelper.snapshotNumber
        snapshot.userInteractionEnabled = false
        snapshot.layer.shadowOpacity = 0.7
        containerView.insertSubview(snapshot, aboveSubview: toVC.view)
        fromVC.view.hidden = true
        
        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            animations: {
                snapshot.center.x += UIScreen.mainScreen().bounds.width * MenuHelper.menuWidth
            },
            completion: { _ in
                fromVC.view.hidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
        )
    }
}

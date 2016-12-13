//
//  MenuHelper.swift
//  iOSApp
//
//  Created by Katie Williams on 12/7/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//  Followed tutorial here: http://www.thorntech.com/2016/03/ios-tutorial-make-interactive-slide-menu-swift/
//

import Foundation
import UIKit

// MARK: - Support for animation of menu

enum Direction {
    case Up
    case Down
    case Left
    case Right
}

struct MenuHelper {
    
    static let menuWidth:CGFloat = 0.8
    
    static let percentThreshold:CGFloat = 0.3
    
    static let snapshotNumber = 12345
    
    
    // MARK: - Calculate the position of view in animation
    static func calculateProgress(translationInView:CGPoint, viewBounds:CGRect, direction:Direction) -> CGFloat {
        let pointOnAxis:CGFloat
        let axisLength:CGFloat
        switch direction {
        case .Up, .Down:
            pointOnAxis = translationInView.y
            axisLength = viewBounds.height
        case .Left, .Right:
            pointOnAxis = translationInView.x
            axisLength = viewBounds.width
        }
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis:Float
        let positiveMovementOnAxisPercent:Float
        switch direction {
        case .Right, .Down: // positive
            positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
            return CGFloat(positiveMovementOnAxisPercent)
        case .Up, .Left: // negative
            positiveMovementOnAxis = fminf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fmaxf(positiveMovementOnAxis, -1.0)
            return CGFloat(-positiveMovementOnAxisPercent)
        }
    }
    
    // MARK: - Use Gestures to trigger MapMenu
    static func mapGestureStateToInteractor(gestureState:UIGestureRecognizerState, progress:CGFloat, interactor: Interactor?, triggerSegue: () -> ()){
        guard let interactor = interactor else { return }
        switch gestureState {
        case .Began:
            interactor.hasStarted = true
            triggerSegue()
        case .Changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.updateInteractiveTransition(progress)
        case .Cancelled:
            interactor.hasStarted = false
            interactor.cancelInteractiveTransition()
        case .Ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finishInteractiveTransition()
                : interactor.cancelInteractiveTransition()
        default:
            break
        }
    }
    
}
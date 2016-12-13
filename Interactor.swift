//
//  Interactor.swift
//  iOSApp
//
//  Created by Katie Williams on 12/7/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//  Followed tutorial here: http://www.thorntech.com/2016/03/ios-tutorial-make-interactive-slide-menu-swift/
//

import UIKit


// MARK: - Interactor class to be used with Animations and Transitions of Menu Open/Close
class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}

//
//  ListViewControllerMenuDelegate.swift
//  GeoNag
//
//  Created by Katie Williams on 12/13/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit

extension ListViewController: MenuActionDelegate {
    
    // MARK: - Menu Controls for Open and Reopen
    
    func openSegue(segueName: String, sender: AnyObject?) {
        dismissViewControllerAnimated(true){
            self.performSegueWithIdentifier(segueName, sender: sender)
        }
    }
    
    func reopenMenu(){
        performSegueWithIdentifier("openMenu", sender: nil)
    }
}

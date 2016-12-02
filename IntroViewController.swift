//
//  IntroViewController.swift
//  iOSApp
//
//  Created by Katie Williams on 12/1/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit
import CoreData

class IntroViewController: UIViewController {

    var currentUser:NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("2hello")
    }
    
    override func viewDidAppear(animated: Bool) {
        print("1hello")
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.coreDataStack.managedObjectContext
        
        let user = appDelegate.fetchRecordsForEntity("User", inManagedObjectContext: managedObjectContext)
        
        if let userInfo = user.first {
            print("hello")
            currentUser = userInfo
            performSegueWithIdentifier("toListView", sender: nil)
        } else {
            performSegueWithIdentifier("toUserLogin", sender: nil)
        }
    }

}
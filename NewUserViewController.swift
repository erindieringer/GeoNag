//
//  NewUserViewController.swift
//  iOSApp
//
//  Created by Katie Williams on 12/1/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit
import CoreData

class NewUserViewController: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    func isEmpty(obj: AnyObject) -> Bool {
        if (obj.text == nil || obj.text == "") {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func saveUser(sender: AnyObject) {
        
        if (isEmpty(firstName) || isEmpty(lastName) || isEmpty(phoneNumber)) {
            let alert = UIAlertController(title: "Incomplete Form", message: "One or more text fields have not been filled in.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedObjectContext = appDelegate.coreDataStack.managedObjectContext
            
            var phone = phoneNumber.text!
            let phoneArray = phone.componentsSeparatedByCharactersInSet(
                NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            phone = NSArray(array: phoneArray).componentsJoinedByString("")
            
            if (phone.characters.count != 10) {
                let alert = UIAlertController(title: "Invalid Phone Number", message: "Phone number has invalid characters.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                // Create new User Entity
                let newUser = appDelegate.createRecordForEntity("User", inManagedObjectContext: managedObjectContext)!
                
                // Set values for new user
                newUser.setValue(firstName.text!, forKey: "firstName")
                newUser.setValue(lastName.text!, forKey: "lastName")
                newUser.setValue(phone, forKey: "phoneNumber")
                appDelegate.coreDataStack.saveContext()
                
                // Get permission for contacts @Erin
                
                
                // Go to List View Controller Page
                performSegueWithIdentifier("UserToView", sender: nil)
            }
            
        }
    }
}

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
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluateWithObject(value)
        return result
    }
    
    @IBAction func saveUser(sender: AnyObject) {
        
        if (isEmpty(firstName) || isEmpty(lastName) || isEmpty(phoneNumber)) {
            let alert = UIAlertController(title: "Alert", message: "One or more text fields have not been filled in. Please try again.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedObjectContext = appDelegate.coreDataStack.managedObjectContext
            
            let newUser = appDelegate.createRecordForEntity("User", inManagedObjectContext: managedObjectContext)!
            newUser.setValue(firstName.text, forKey: "firstName")
            newUser.setValue(lastName.text, forKey: "lastName")
            let phone = phoneNumber.text
            
        }
    }
}

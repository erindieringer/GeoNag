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
    
    // Source: http://stackoverflow.com/questions/27998409/email-phone-validation-in-swift
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluateWithObject(value)
        return result
    }
    
    @IBAction func saveUser(sender: AnyObject) {
        
        if (isEmpty(firstName) || isEmpty(lastName) || isEmpty(phoneNumber)) {
            let alert = UIAlertController(title: "Incomplete Form", message: "One or more text fields have not been filled in.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedObjectContext = appDelegate.coreDataStack.managedObjectContext
            
            let phone = phoneNumber.text!
            if (validate(phone) == false) {
                let alert = UIAlertController(title: "Invalid Phone Number", message: "Phone number has invalid characters.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                // Create new User Entity
                let newUser = appDelegate.createRecordForEntity("User", inManagedObjectContext: managedObjectContext)!
                // Set values for new user
                newUser.setValue(firstName.text!, forKey: "firstName")
                newUser.setValue(lastName.text!, forKey: "lastName")
                let phoneArray = phone.componentsSeparatedByCharactersInSet(
                    NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                let fixedPhoneNumber = NSArray(array: phoneArray).componentsJoinedByString("")
                newUser.setValue(fixedPhoneNumber, forKey: "phoneNumber")
                
                // Get permission for contacts @Erin
                
                
                // Go to List View Controller Page
                performSegueWithIdentifier("UserToView", sender: nil)
            }
            
        }
    }
}

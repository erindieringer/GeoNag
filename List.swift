//
//  List.swift
//  iOSApp
//
//  Created by Katie Williams on 11/28/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation
import CoreData

@objc(List)
class List: NSManagedObject {
    
// Insert code here to add functionality to your managed object subclass
    
    func assignAttributes(delegate: AppDelegate, name: String, currentUser: Int) {
        self.setValue(name, forKey: "name")
        self.setValue(NSDate(), forKey: "dateCreated" )
        self.setValue(NSDate(), forKey: "dateModified")
        self.setValue(0, forKey: "shared")
        self.setValue(1, forKey: "notifications")
        //self.setValue(currentUser, forKey: "user")
        self.setValue([], forKey: "items")
        self.setValue([], forKey: "friends")
        // save entity
        delegate.saveContext()
    }

}

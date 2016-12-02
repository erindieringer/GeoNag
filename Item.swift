//
//  Item.swift
//  iOSApp
//
//  Created by Katie Williams on 11/28/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
class Item: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    func assignAttributes(delegate: AppDelegate, text: String, list: List) {
        self.setValue(text, forKey: "text")
        self.setValue(NSOrderedSet(), forKey: "tags" )
        self.setValue(list, forKey: "list")
        // save entity
        delegate.coreDataStack.saveContext()
    }
    
}

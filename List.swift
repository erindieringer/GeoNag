//
//  List.swift
//  iOSApp
//
//  Created by Katie Williams on 11/28/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation
import CoreData

//@objc(List)
class List: NSManagedObject {
    
// Insert code here to add functionality to your managed object subclass
    
    func assignAttributes(delegate: AppDelegate, name: String) {
        self.setValue(name, forKey: "name")
        // save entity
        delegate.saveContext()
    }

}

//
//  List+CoreDataProperties.swift
//  iOSApp
//
//  Created by Katie Williams on 11/28/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension List {

    @NSManaged var name: String?
    @NSManaged var dateCreated: NSDate?
    @NSManaged var dateModified: NSDate?
    @NSManaged var shared: NSNumber?
    @NSManaged var notifications: NSNumber?
    @NSManaged var user: User?
    @NSManaged var items: NSOrderedSet?
    @NSManaged var friends: NSOrderedSet?

}

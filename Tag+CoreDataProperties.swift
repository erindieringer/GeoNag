//
//  Tag+CoreDataProperties.swift
//  iOSApp
//
//  Created by Katie Williams on 12/6/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tag {

    @NSManaged var name: String?
    @NSManaged var locations: NSOrderedSet?
    @NSManaged var lists: List?

}

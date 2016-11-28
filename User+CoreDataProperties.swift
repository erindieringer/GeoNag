//
//  User+CoreDataProperties.swift
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

extension User {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var imageSrc: String?
    @NSManaged var lists: NSOrderedSet?

}

//
//  List.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//
import Foundation
import UIKit
import CoreData

public class List: NSManagedObject {
    @NSManaged public var id: Int
    @NSManaged public var name: String
    @NSManaged public var date_created: NSDate
    @NSManaged public var date_modified: NSDate
    @NSManaged public var shared: Bool
    @NSManaged public var user: Int
    @NSManaged public var items: [Reminder]
    @NSManaged public var notifications: Bool

class func createManagedObjectContextEntity(moc: NSManagedObjectContext, name: String) -> List {
    let newItem = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: moc) as! List
    newItem.name = name
    return newItem
}
}

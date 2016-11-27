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
    @NSManaged private var id: Int
    @NSManaged private var name: String
    @NSManaged private var date_created: NSDate
    @NSManaged private var date_modified: NSDate
    @NSManaged private var shared: Bool
    @NSManaged private var user: Int
    @NSManaged private var items: [Reminder]
    @NSManaged private var notifications: Bool
}

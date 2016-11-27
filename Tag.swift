//
//  Tag.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation
import CoreData

public class Tag: NSManagedObject {
    @NSManaged public var id: Int
    @NSManaged public var name: String
}

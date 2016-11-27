//
//  Tag.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation
import CoreData

private class Tag: NSManagedObject {
    @NSManaged private var id: Int
    @NSManaged private var name: String
}

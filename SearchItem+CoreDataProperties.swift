//
//  SearchItem+CoreDataProperties.swift
//  GeoNag
//
//  Created by Katie Williams on 12/9/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SearchItem {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?

}

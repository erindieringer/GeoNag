//
//  CoreDataHelper.swift
//  GeoNag
//
//  Created by Katie Williams on 12/13/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct CoreDataHelper {
    
    var coreDataStack: CoreDataStack {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.coreDataStack
    }
    
    // MARK: - Core Data Method for Creating Records
    
    func createRecordForEntity(entity: String) -> NSManagedObject? {
        // Helpers
        var result: NSManagedObject? = nil
        let managedObjectContext = coreDataStack.managedObjectContext
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName(entity, inManagedObjectContext: managedObjectContext)
        
        if let entityDescription = entityDescription {
            // Create Managed Object
            result = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
        }
        return result
    }
    
    // MARK: - Core Data Method for Fetching Records
    
    func fetchRecordsForEntity(entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext, predicate:NSPredicate?=nil, sortDescriptor: NSSortDescriptor?=nil) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest(entityName: entity)
        
        if (predicate != nil) {
            fetchRequest.predicate = predicate
        }
        
        if (sortDescriptor != nil) {
            fetchRequest.sortDescriptors = [sortDescriptor!]
        }
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        return result
    }
}
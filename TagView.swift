//
//  TagView.swift
//  iOSApp
//
//  Created by Katie Williams on 12/7/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TagView {
    var tags = [Tag]()
    
    var numberOfTags = 8
    
    // only run once! Adds all programmed tags to coredata
    func createAllTags() ->[Tag] {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.coreDataStack.managedObjectContext
        
        let tagNames = ["Groceries", "Convenience", "Drug", "Post", "Bank", "Beverage", "Home", "Sports"]
        
        for i in 0..<numberOfTags {
            if let tagEntity = appDelegate.createRecordForEntity("Tag", inManagedObjectContext: managedContext) {
                
                // set values of new tag entity
                tagEntity.setValue(tagNames[i], forKey: "name")
                tagEntity.setValue(NSOrderedSet(), forKey: "lists" )
                tagEntity.setValue(NSOrderedSet(), forKey: "locations")
        
                let tag = tagEntity
                tags.append(tag as! Tag)
            }
        }
        
        appDelegate.coreDataStack.saveContext()
        
        return tags
    }
    
    func fetchAllTags(predicate:NSPredicate?=nil) -> [Tag]?{
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.coreDataStack.managedObjectContext
        
        let allTags = appDelegate.fetchRecordsForEntity("Tag", inManagedObjectContext: managedContext, predicate: predicate) as! [Tag]
        
        return allTags
    }
    
    func tagsExist() -> Bool {
        let tags = fetchAllTags()
        if tags?.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func titleForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        let index = indexPath.row
        if index < 0 || index >= numberOfTags {
            return ""
        }
        let returnTag = tags[index]
        let returnName = returnTag.name!
        return returnName
    }
    
    func iconForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        print("iconNames[0]")
        return ""
    }
    
    
}

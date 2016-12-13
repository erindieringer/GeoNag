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

struct TagView {
    
    // define core data helper to manage core data objects
    var coreDataHelper = CoreDataHelper()
    var tags = [Tag]()
    // selected tag img files
    var tagImages:NSArray = ["groceries.png", "convenience.png", "drug", "post.png", "bank", "beverage.png", "home.png", "sports.png"]
    // unselected tag img files
    var oTagImages:NSArray = ["ogroceries.png", "oconvenience.png", "odrug", "opost.png", "obank", "obeverage.png", "ohome.png", "osports.png"]
    
    // as of now with this iteration tags are static
    var numberOfTags = 8
    
    // MARK: - Tag Creation, Fetching, and Displaying as CollectionView
    
    // only run once! Adds all programmed tags to coredata
    mutating func createAllTags() ->[Tag] {
        let tagNames = ["Groceries", "Convenience", "Drug", "Post", "Bank", "Beverage", "Home", "Sports"]
        
        for i in 0..<numberOfTags {
            if let tagEntity = coreDataHelper.createRecordForEntity("Tag") {
                
                // set values of new tag entity
                tagEntity.setValue(tagNames[i], forKey: "name")
                tagEntity.setValue(NSOrderedSet(), forKey: "lists" )
                tagEntity.setValue(NSOrderedSet(), forKey: "locations")
        
                let tag = tagEntity
                tags.append(tag as! Tag)
            }
        }
        
        coreDataHelper.coreDataStack.saveContext()
        
        return tags
    }
    
    func fetchAllTags(predicate:NSPredicate?=nil) -> [Tag]?{
        
        let allTags = coreDataHelper.fetchRecordsForEntity("Tag") as! [Tag]
        
        return allTags
    }
    
    // returns true only if tag array is not empty
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
}

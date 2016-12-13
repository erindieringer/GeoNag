//
//  ListDetailViewModel.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ListDetailView {
    
    var items = [Item]() // items in list
    var reminderList: List // list that was clicked
    
    // initialize coreDataHelper to manage coredata functions
    var coreDataHelper = CoreDataHelper()
    
    init(list: List) {
        reminderList = list
    }
    
    // get title of given reminder list
    func title() -> String {
        if let name = reminderList.name {
            return name
        } else {
            print("Error getting List title")
            return ""
        }
    }
    
    // get tags of given reminder list
    func getTags() -> [Tag] {
        return reminderList.tags!.array as! [Tag]
    }
    
    // MARK: - Add Tags for List
    func addTag(tag:Tag) {
        let mutableList = reminderList.tags?.mutableCopy() as! NSMutableOrderedSet
        mutableList.addObject(tag)
        reminderList.tags = mutableList.copy() as? NSOrderedSet
        coreDataHelper.coreDataStack.saveContext()
    }
    
    // MARK: - Delete Tags for List
    func deleteTag(tag:Tag) {
        let mutableList = reminderList.tags?.mutableCopy() as! NSMutableOrderedSet
        mutableList.removeObject(tag)
        reminderList.tags = mutableList.copy() as? NSOrderedSet
        coreDataHelper.coreDataStack.saveContext()
    }
    
    // MARK: - Functions to Retrieve Tags for List
    func getReminderItems() -> [Item] {
        return reminderList.items!.array as! [Item]
    }
    
    func numberOfRows() -> Int {
        return reminderList.items!.count
    }
    
    func textForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        let index = indexPath.row
        if index < 0 || index >= numberOfRows() {
            return ""
        }
        let reminderItem = reminderList.items![index] as! Item
        let reminderString = reminderItem.text!
        return reminderString
    }
    
    
    
}

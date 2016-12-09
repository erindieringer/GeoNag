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
    var items = [Item]()
    var reminderList: List
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    init(list: List) {
        reminderList = list
    }
    
    func title() -> String {
        return reminderList.name!
    }
    
    func getTags() -> [Tag] {
        return reminderList.tags!.array as! [Tag]
    }
    
    func addTag(tag:Tag) {
        let mutableList = reminderList.tags?.mutableCopy() as! NSMutableOrderedSet
        mutableList.addObject(tag)
        reminderList.tags = mutableList.copy() as? NSOrderedSet
        appDelegate.coreDataStack.saveContext()
    }
    
    func deleteTag(tag:Tag) {
        let mutableList = reminderList.tags?.mutableCopy() as! NSMutableOrderedSet
        mutableList.removeObject(tag)
        reminderList.tags = mutableList.copy() as? NSOrderedSet
        appDelegate.coreDataStack.saveContext()
    }
    
    func getReminderItems() -> [Item] {
        // if there is a problem with this, loop through the NSOrdered Set and recreate Item Objects
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

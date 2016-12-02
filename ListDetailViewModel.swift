//
//  ListDetailViewModel.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation
import CoreData

class ListDetailViewModel {
    var items = [NSManagedObject]()
    var reminderList: List
    
    init(list: List) {
        reminderList = list
    }
    
    func title() -> String {
        return reminderList.name!
    }
    
    func getSharedUserInitials() -> [String] {
        //let currentUser = reminderList.user
        // TO DO: Call up to the API and get user's friends
        return ["KW", "ED"]
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

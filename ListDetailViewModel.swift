//
//  ListDetailViewModel.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation

class ListDetailViewModel {
    var reminderList: List
    
    init(list: List) {
        reminderList = list
    }
    
    func title() -> String {
        return reminderList.name
    }
    
    func getSharedUserInitials() -> [String] {
        //let currentUser = reminderList.user
        // TO DO: Call up to the API and get user's friends
        return ["KW", "ED"]
    }
    
    func getReminderItems() -> [Reminder] {
        return reminderList.items
    }
    
    func numberOfRows() -> Int {
        return reminderList.items.count
    }
    
    func textForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        let index = indexPath.row
        if index < 0 || index >= numberOfRows() {
            return ""
        }
        let retString = reminderList.items[index].text
        return retString
    }
    
    
    
}

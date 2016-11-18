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
        reminderList = List(id: list.id, name: list.name, date_created: list.date_created, date_modified: list.date_modified, shared: list.shared, user: list.user, items: list.items)
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
    
    
    
}

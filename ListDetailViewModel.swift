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
        reminderList = List(id: list.id, name: list.name, date_created: list.date_created, date_modified: list.date_modified, shared: list.shared, user: list.user)
    }
    
    func title()
    
    func getSharedUserNames()
    
    func 
    
}

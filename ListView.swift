//
//  ListViewModel.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation
import CoreData

class ListView {
    // create list of lists for local changes
    var lists = [List]()
    
    
    // MARK: - Functions to control Lists Table in List View Model
    
    func numberOfRows() -> Int {
        return lists.count
    }
    
    // MARK: - Get Title
    func titleForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        let index = indexPath.row
        if index < 0 || index >= numberOfRows() {
            return ""
        }
        let returnList = lists[index]
        let listName = returnList.name!
        return listName
    }
    
    // MARK: - Get List Item View
    func detailViewModelForRowAtIndexPath(indexPath: NSIndexPath) -> ListDetailView {
        let list = lists[indexPath.item]
        let detailVM = ListDetailView(list: list)
        return detailVM
    }
    
    // MARK: - Get List in Table
    func getListForIndexPath(indexPath:NSIndexPath) -> NSManagedObject {
        return lists[indexPath.item]
    }
    
}
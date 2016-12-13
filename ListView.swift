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
    
    // MARK: - Get Summary
    func summaryForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        var returnString = ""
        let index = indexPath.row
        guard index >= 0 && index < lists.count else {
            return ""
        }
        let returnList = lists[index]
        if let listItems = returnList.items {
            let listItemsArray = listItems.array as! [Item]
            for i in 0..<listItems.count {
                returnString += (listItemsArray[i].text! + " ")
            }
            return returnString
        } else {
            return ""
        }
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
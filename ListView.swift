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
    var lists = [List]()
    
    func numberOfRows() -> Int {
        return lists.count
    }
    
    func titleForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        let index = indexPath.row
        if index < 0 || index >= numberOfRows() {
            return ""
        }
        let returnList = lists[index]
        let listName = returnList.name!
        return listName
    }
    
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
    
    func detailViewModelForRowAtIndexPath(indexPath: NSIndexPath) -> ListDetailView {
        let list = lists[indexPath.item]
        let detailVM = ListDetailView(list: list)
        return detailVM
    }
    
    func getListForIndexPath(indexPath:NSIndexPath) -> NSManagedObject {
        return lists[indexPath.item]
    }
    
}
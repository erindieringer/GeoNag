//
//  ListViewModel.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation
import CoreData

class ListViewModel {
    var lists = [NSManagedObject]()
    
    func numberOfRows() -> Int {
        return lists.count
    }
    
    func titleForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        let index = indexPath.row
        if index < 0 || index >= numberOfRows() {
            return ""
        }
        let returnList = lists[index] as! List
        let listName = returnList.name!
        return listName
    }
    
    func detailViewModelForRowAtIndexPath(indexPath: NSIndexPath) -> ListDetailViewModel {
        let list = lists[indexPath.item] as! List
        let detailVM = ListDetailViewModel(list: list)
        return detailVM
    }
    
}
//
//  ListViewModel.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation

class ListViewModel {
    var lists = [List]()
    
    func numberOfRows() -> Int {
        return lists.count
    }
    
    func titleForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        let index = indexPath.row
        if index < 0 || index >= numberOfRows() {
            return ""
        }
        let retString = lists[index].name
        return retString!
    }
    
    func detailViewModelForRowAtIndexPath(indexPath: NSIndexPath) -> ListDetailViewModel {
        let ret = ListDetailViewModel(list: lists[indexPath.item])
        return ret
    }
    
}
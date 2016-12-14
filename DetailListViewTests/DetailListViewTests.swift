//
//  DetailListViewTests.swift
//  DetailListViewTests
//
//  Created by Katie Williams on 12/13/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//
// READ ME IMPORTANT: Clean the build before running tests : shift - cntrl - k, and all errors about not recognizing the idenfier for the models will go away and the tests will pass
//

import XCTest
@testable import GeoNag
import CoreData

class DetailListViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_getTitle() {
        createList("Grocery")
        let list = getList()
        
        let detailVC = ListDetailView(list: list as! List)
        let title = detailVC.title()
        
        XCTAssertEqual(list.valueForKey("name") as? String, title)
        deleteLists()
        
      
    }
    
    func test_getTags() {
        
        
    }
    
    func test_addTag() {
        
    }
    
    func test_deleteTag() {
        
    }
    
    func test_getReminderItems() {

    }
    
    func test_numberOfRows() {
        
        
        
        
    }
    
    func test_textForRowAtIndexPath() {
        
    }
    
    //Helper function to retreive list from CoreData for items
    func getList() -> NSManagedObject {
        let coreDataHelper = CoreDataHelper()
        var list: [NSManagedObject] = []
        let fetchRequest = NSFetchRequest(entityName: "List")
        let managedObjectContext = coreDataHelper.coreDataStack.managedObjectContext
        do {
            
            if let records = try? managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]{
                list = records
            }
        }
        let result = list[0]
        return result

    }
    
    //Helper function to create list for items
    func createList(name: String) {
        let coreDataHelper = CoreDataHelper()
        let listEntity = (coreDataHelper.createRecordForEntity("List"))!
        
        // set values of new list entity
        listEntity.setValue(name, forKey: "name")
        listEntity.setValue(NSDate(), forKey: "dateCreated" )
        listEntity.setValue(NSDate(), forKey: "dateModified")
        listEntity.setValue(0, forKey: "shared")
        listEntity.setValue(1, forKey: "notifications")
        listEntity.setValue(NSOrderedSet(), forKey: "items")
        listEntity.setValue(NSOrderedSet(), forKey: "tags" )
        listEntity.setValue(NSOrderedSet(), forKey: "friends")
        
        // save entity
        coreDataHelper.coreDataStack.saveContext()
    }
    
    //Helper function to clear CoreData
    func deleteLists() {
        let coreDataHelper = CoreDataHelper()
        let fetchRequest = NSFetchRequest(entityName: "List")
        let managedObjectContext = coreDataHelper.coreDataStack.managedObjectContext
        do {
            
            if let records = try? managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]{
                for object in records {
                    managedObjectContext.deleteObject(object)
                    try!managedObjectContext.save()
                    
                }
            }
        }
        
    }
    
    //Helper function to clear CoreData
    func deleteItems() {
        let coreDataHelper = CoreDataHelper()
        let fetchRequest = NSFetchRequest(entityName: "Item")
        let managedObjectContext = coreDataHelper.coreDataStack.managedObjectContext
        do {
            
            if let records = try? managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]{
                for object in records {
                    managedObjectContext.deleteObject(object)
                    try!managedObjectContext.save()
                    
                }
            }
        }
        
    }
    
}

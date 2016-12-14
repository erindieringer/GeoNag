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
        createList("Grocery")
        let list = getList()
        
        let detailVC = ListDetailView(list: list as! List)
        let tags = createTags()
        
        detailVC.addTag(tags[0])
        let tagsInUse = detailVC.getTags()
        
        XCTAssertEqual(tagsInUse[0], tags[0])
    
        deleteTags()
        deleteLists()
    }
    
    
    func test_getReminderItems() {
        createList("Grocery")
        let list = getList()
        
        let detailView = ListDetailView(list: list as! List)
        
        createItem("eggs", list: (list as NSManagedObject))
        createItem("milk", list: (list as NSManagedObject))
        createItem("bacon", list: (list as NSManagedObject))
        
        XCTAssertEqual(detailView.getReminderItems().count, 3)
        XCTAssertEqual(detailView.getReminderItems().map{($0 as Item).text!}.sort(), ["bacon", "eggs", "milk"])
        
        deleteItems()
        deleteLists()
        
    }
    
    func test_numberOfRows() {
        createList("Grocery")
        let list = getList()
        
        let detailView = ListDetailView(list: list as! List)
        
        XCTAssertEqual(detailView.numberOfRows(), 0)
        
        createItem("eggs", list: (list as NSManagedObject))
        createItem("milk", list: (list as NSManagedObject))
        createItem("bacon", list: (list as NSManagedObject))
        
        XCTAssertEqual(detailView.numberOfRows(), 3)
        
        deleteItems()
        deleteLists()
    }
    
    func test_textForRowAtIndexPath() {
        createList("Grocery")
        let list = getList()
        
        let detailView = ListDetailView(list: list as! List)
        
        let index = NSIndexPath(forRow:0, inSection: 0)
        XCTAssertEqual(detailView.textForRowAtIndexPath(index), "")
        
        createItem("eggs", list: (list as NSManagedObject))
        
        XCTAssertEqual(detailView.textForRowAtIndexPath(index), "eggs")
        
        deleteItems()
        deleteLists()
        
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
    
    //Helper function to create items for list
    func createItem(text: String, list: NSManagedObject) {
        let coreDataHelper = CoreDataHelper()
        let listEntity = (coreDataHelper.createRecordForEntity("Item"))!
        
        // set values of new item entity
        listEntity.setValue(text, forKey: "text")
        listEntity.setValue(list, forKey: "list" )
        
        // save entity
        coreDataHelper.coreDataStack.saveContext()
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
    

    func createTags() -> [Tag] {
        var tagView = TagView()
        let tags = tagView.createAllTags()
        return tags
    }
    
    //Helper function to remove tags from core data
    func deleteTags() {
        let coreDataHelper = CoreDataHelper()
        let fetchRequest = NSFetchRequest(entityName: "Tag")
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




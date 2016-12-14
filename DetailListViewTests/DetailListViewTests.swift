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
        let list = List()
        list.name = "Reminders"
        let listDetailView = ListDetailView(list: list)
        
        XCTAssertEqual("Reminders", listDetailView.title())
    }
    
    func test_getTags() {
        
        
    }
    
    func test_addTag() {
        
    }
    
    func test_deleteTag() {
        
    }
    
    func test_getReminderItems() {
        let list = List()
        list.name = "Reminders"
        let listDetailView = ListDetailView(list: list)
        let item1 = Item()
        item1.text = "milk"
        let item2 = Item()
        item2.text = "eggs"
        listDetailView.items = [item1, item2]
        
        XCTAssertEqual(["eggs", "milk"], listDetailView.getReminderItems().map { $0.text! }.sort())
    }
    
    func test_numberOfRows() {
        
        
    }
    
    func test_textForRowAtIndexPath() {
        
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

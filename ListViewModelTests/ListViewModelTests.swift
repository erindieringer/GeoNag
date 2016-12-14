//
//  ListViewModelTests.swift
//  ListViewModelTests
//
//  Created by Erin Dieringer on 12/13/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//
// READ ME IMPORTATNT: Clean the build before running tests : shift - cntrl - k, and all errors about not recognizing the idenfier for the models will go away and the tests will pass

import XCTest
@testable import GeoNag
import CoreData

class ListViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_numberOfRows() {
        let view = ListView()
        createList(view, name: "Grocery")
        createList(view, name: "To Do" )
        createList(view, name: "Target")
        
        XCTAssertEqual(view.numberOfRows(), 3)
        
        deleteLists()
        
    }
    func test_titleForRowAtIndexPath() {
        let view = ListView()
        createList(view, name: "Grocery")
        createList(view, name: "To Do" )
        createList(view, name: "Target")
        
        let indexPath1 = NSIndexPath(forRow: 0, inSection: 0)
        XCTAssertEqual(view.titleForRowAtIndexPath(indexPath1), "Target")
        
        let indexPath2 = NSIndexPath(forRow: 1, inSection: 0)
        XCTAssertEqual(view.titleForRowAtIndexPath(indexPath2), "To Do")
        
        let indexPath3 = NSIndexPath(forRow: 2, inSection: 0)
        XCTAssertEqual(view.titleForRowAtIndexPath(indexPath3), "Grocery")
        
        deleteLists()
    }
    
    func test_detailViewModelForRowAtIndexPath() {
        let coreDataHelper = CoreDataHelper()
        let view = ListView()
        createList(view, name: "Grocery")
        createList(view, name: "To Do" )
        createList(view, name: "Target")
        
        let indexPath = NSIndexPath(forRow: 1, inSection: 0)
        let detailVM = view.detailViewModelForRowAtIndexPath(indexPath)
        
        var repo2: [NSManagedObject] = []
        
        let fetchRequest = NSFetchRequest(entityName: "List")
        let pred = NSPredicate(format: "name = 'To Do'")
        fetchRequest.predicate = pred
        let managedObjectContext = coreDataHelper.coreDataStack.managedObjectContext
        do {
            
            if let records = try? managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]{
                repo2 = records
            }
        }
        let result = repo2[0]
        XCTAssertEqual(detailVM.reminderList.name!, result.valueForKey("name") as? String)
        
        deleteLists()
    }
    
    func test_getListForIndexPath() {
        let coreDataHelper = CoreDataHelper()
        let view = ListView()
        createList(view, name: "Grocery")
        createList(view, name: "To Do" )
        createList(view, name: "Target")
        
        //Get middle repo
        var repo2: [NSManagedObject] = []
        let fetchRequest = NSFetchRequest(entityName: "List")
        let pred = NSPredicate(format: "name = 'To Do'")
        fetchRequest.predicate = pred
        let managedObjectContext = coreDataHelper.coreDataStack.managedObjectContext
        do {
            
            if let records = try? managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]{
                repo2 = records
            }
        }
        let result = repo2[0]
        
        let indexPath2 = NSIndexPath(forRow: 1, inSection: 0)
        XCTAssertEqual(view.getListForIndexPath(indexPath2), result)
        
        deleteLists()
        
    }
    
    
    
    //helper to create lists
    func createList(viewModel: ListView, name: String){
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
        viewModel.lists.insert(listEntity as! List, atIndex:0)

        // save entity
        coreDataHelper.coreDataStack.saveContext()
        
    }
    
    //helper to delete lists
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
    
}

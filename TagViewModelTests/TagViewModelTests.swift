//
//  TagViewModelTests.swift
//  TagViewModelTests
//
//  Created by Erin Dieringer on 12/13/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//
// READ ME IMPORTATNT: Clean the build before running tests : shift - cntrl - k, and all errors about not recognizing the idenfier for the models will go away and the tests will pass

import XCTest
@testable import GeoNag
import CoreData

class TagViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_createTags() {
        var view = TagView()
        let tags = view.tags
        
        XCTAssertEqual(0, tags.count)
        
        let tagResults = view.createAllTags()
        XCTAssertEqual(8, tagResults.count)
        
        deleteTags()
    }
    
    func test_fetchAllTags() {
        var view = TagView()
        let tags = view.tags
        
        view.createAllTags()
        let results = view.fetchAllTags()
        XCTAssertEqual(8, results!.count)
        
        deleteTags()
    }
    
    func test_tagsExist() {
        var view = TagView()
        let tags = view.tags
        
        view.createAllTags()
        let areTags = view.tagsExist()
        XCTAssertTrue(areTags)

        deleteTags()
        
    }
    
    
    
    //Helper function to clear CoreData
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

//
//  CurrentLocationTests.swift
//  CurrentLocationTests
//
//  Created by Erin Dieringer on 12/13/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
// 
// READ ME IMPORTATNT: Clean the build before running tests : shift - cntrl - k, and all errors about not recognizing the idenfier for the models will go away and the tests will pass

import XCTest
@testable import GeoNag

class CurrentLocationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()


       
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_init() {
        let currentLocation = CurrentLocation()
        let latitude = currentLocation.latitude
        let longitude = currentLocation.longitude
        XCTAssertEqual(0.0, latitude)
        XCTAssertEqual(0.0, longitude)
    }
    
    func test_getSearchItems() {
        let currentLocation = CurrentLocation()
        let coreDataHelper = CoreDataHelper()
        let newItem = coreDataHelper.createRecordForEntity("SearchItem")!
        newItem.setValue("Kroger", forKey: "name")
        newItem.setValue(40.0, forKey: "latitude")
        newItem.setValue(30.0, forKey: "longitude")
        
        let results = currentLocation.getSearchItems()
        XCTAssertEqual(1, results.count)
        
        let name = results[0].valueForKey("name")! as! String
        XCTAssertEqual("Kroger", name)
        
        let longitude =  results[0].valueForKey("longitude")! as! Double
        let latitude =  results[0].valueForKey("latitude")! as! Double
        XCTAssertEqual(40.0, latitude)
        XCTAssertEqual(30.0, longitude)
        
        
        currentLocation.deleteSearchItems()

    }
    
    func test_deleteSearchItems() {
        let currentLocation = CurrentLocation()
        let coreDataHelper = CoreDataHelper()
        let newItem1 = coreDataHelper.createRecordForEntity("SearchItem")!
        newItem1.setValue("Kroger", forKey: "name")
        newItem1.setValue(40.0, forKey: "latitude")
        newItem1.setValue(30.0, forKey: "longitude")
        
        let newItem2 = coreDataHelper.createRecordForEntity("SearchItem")!
        newItem2.setValue("Kroger", forKey: "name")
        newItem2.setValue(40.0, forKey: "latitude")
        newItem2.setValue(30.0, forKey: "longitude")
        
        let newItem3 = coreDataHelper.createRecordForEntity("SearchItem")!
        newItem3.setValue("Kroger", forKey: "name")
        newItem3.setValue(40.0, forKey: "latitude")
        newItem3.setValue(30.0, forKey: "longitude")
        
        let results = currentLocation.getSearchItems()
        XCTAssertEqual(3, results.count)
        
        
        currentLocation.deleteSearchItems()
        
        let newResults = currentLocation.getSearchItems()
        XCTAssertEqual(0,newResults.count)
    }
    
   
    
}

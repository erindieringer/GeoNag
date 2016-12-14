//
//  DataManagerTests.swift
//  DataManagerTests
//
//  Created by Erin Dieringer on 12/13/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//
// READ ME IMPORTATNT: Clean the build before running tests : shift - cntrl - k, and all errors about not recognizing the idenfier for the models will go away and the tests will pass

import XCTest
@testable import GeoNag

class DataManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_saveLocation() {
        let currentLocation = CurrentLocation()
        currentLocation.latitude = 30.0
        currentLocation.longitude = 31.0
        let manager = DataManager()
        manager.location = currentLocation
        manager.saveLocation()
        
        var resultLatitude = 0.0
        var resultLongitude = 0.0
        let path = manager.dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                if let lat = unarchiver.decodeObjectForKey("currentLatitude") as? Double {
                    resultLatitude = lat
                }
                if let long = unarchiver.decodeObjectForKey("currentLongitude") as? Double {
                    resultLongitude = long
                }
                unarchiver.finishDecoding()
            } else {
                print("\nFILE NOT FOUND AT: \(path)")
            }
        }
        XCTAssertEqual(30.0, resultLatitude)
        XCTAssertEqual(31.0, resultLongitude)
        
    }
    
    func test_loadLocation() {
        let manager = DataManager()
        manager.loadLocation()
        
        
        manager.location.latitude = 10.0
        manager.location.longitude = 20.0
        
        manager.saveLocation()
        manager.loadLocation()

        XCTAssertEqual(10.0, manager.location.latitude)
        XCTAssertEqual(20.0,  manager.location.longitude)
        
        
    }
    
  
    
}

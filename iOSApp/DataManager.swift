//
//  DataManager.swift
//  iOSApp
//
//  Created by Erin Dieringer on 12/8/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//  CODE USED FROM PROF H FindMyCarLAb

import Foundation
import CoreLocation


// MARK: - String Extension
extension String {
    func stringByAppendingPathComponent(aPath: String) -> String {
        let nsSt = self as NSString
        return nsSt.stringByAppendingPathComponent(aPath)
    }
}


// MARK: - Data Manager Class
class DataManager {
    
    // MARK: - General
    var location = CurrentLocation()
    
    init() {
        loadLocation()
        print("Documents folder is \(documentsDirectory())\n")
        print("Data file path is \(dataFilePath())")
    }
    
    
    // MARK: - Data Location Methods
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return documentsDirectory().stringByAppendingPathComponent("CurrentLocation.plist")
    }
    
    
    // MARK: - Saving & Loading Data
    
 
    // saves location to plist
    func saveLocation() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(location.latitude, forKey: "currentLatitude")
        archiver.encodeObject(location.longitude, forKey: "currentLongitude")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
   
    // Loads the data from a plist into location array.
    func loadLocation() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                if let lat = unarchiver.decodeObjectForKey("currentLatitude") as? CLLocationDegrees {
                    self.location.latitude = lat
                }
                if let long = unarchiver.decodeObjectForKey("currentLongitude") as? CLLocationDegrees {
                    self.location.longitude = long
                }
                unarchiver.finishDecoding()
            } else {
                print("\nFILE NOT FOUND AT: \(path)")
            }
        }
        
    }
}
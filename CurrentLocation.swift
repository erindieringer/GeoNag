//
//  LocationManager.swift
//  iOSApp
//
//  Created by Erin Dieringer on 11/19/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import MapKit
import CoreLocation
import UIKit
import CoreData

class CurrentLocation {
    
    let manager = CLLocationManager()
    var matchingItems:[MKMapItem] = []
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    // define core data helper to manage core data objects
    var coreDataHelper = CoreDataHelper()
    
    let plist =  PlistManager.sharedInstance
    
    //Intitialize to zero before calling getCurrentLocation()
    init() {
        self.latitude = 0.0
        self.longitude = 0.0
    }
    
    func getCurrentLocation() {
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.distanceFilter = kCLDistanceFilterNone
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()
        }
        
        if let currLocation = manager.location {
            self.latitude = currLocation.coordinate.latitude
            self.longitude = currLocation.coordinate.longitude
        }
    }
    
    //Given tag, find resulting matching items and save to coreData
    func findMatchingItems(tag: String, region: MKCoordinateRegion) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = tag
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, _ in
        
            guard let response = response else {
                return
            }
            let match = response.mapItems
            if (match.count > 0){
                for item in match {
                    let newItem = self.coreDataHelper.createRecordForEntity("SearchItem")!
                    //save to coredata
                    newItem.setValue(item.name, forKey: "name")
                    newItem.setValue(item.placemark.coordinate.latitude, forKey: "latitude")
                    newItem.setValue(item.placemark.coordinate.longitude, forKey: "longitude")
                }
            }
        
        }
    
    }
    
    
    // MARK: Added new plist functions that will get and store current location of user in plist for more accessibility
    func getPlistUserLocation () {
        let plistLong = plist.getValueForKey("userCurrentLocationLongitude")
        let plistLat = plist.getValueForKey("userCurrentLocationLatitude")
        self.longitude = CLLocationDegrees(plistLong as! NSNumber)
        self.latitude = CLLocationDegrees(plistLat as! NSNumber)
    }
    
    func savePlistUserLocation(){
        plist.saveValue( NSNumber(double: self.longitude), forKey: "UserCurrentLocationLongitude")
        plist.saveValue( NSNumber(double: self.latitude), forKey: "UserCurrentLocationLatitude")
    }
    
 
}
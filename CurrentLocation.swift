//
//  LocationManager.swift
//  iOSApp
//
//  Created by Erin Dieringer on 11/19/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import MapKit
import CoreLocation

class CurrentLocation {
    
    let manager = CLLocationManager()
    var matchingItems:[MKMapItem] = []
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    //intitialize to zero before calling getCurrentLocation()
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
    
    func findMatchingItems(tag: String, region: MKCoordinateRegion) -> [MKMapItem] {
        // region will have to be passed in (template below)
        //      let span = MKCoordinateSpanMake(0.05, 0.05)
        //      let region = MKCoordinateRegion(center: location.coordinate, span: span)
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = tag
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            for item in self.matchingItems {
                print(item)
            
            }
        }
        
        return self.matchingItems
    }
    
    // MARK: Added new plist functions that will get and store current location of user in plist for more accessibility
    
    func getPlistUserLocation () {
        let plistLong = PlistManager.sharedInstance.getValueForKey("UserCurrentLocationLongitude")
        let plistLat = PlistManager.sharedInstance.getValueForKey("UserCurrentLocationLatitude")
        self.longitude = CLLocationDegrees(plistLong as! NSNumber)
        self.latitude = CLLocationDegrees(plistLat as! NSNumber)
    }
    
    func savePlistUserLocation(){
        PlistManager.sharedInstance.saveValue( NSNumber(double: self.longitude), forKey: "UserCurrentLocationLongitude")
        PlistManager.sharedInstance.saveValue( NSNumber(double: self.latitude), forKey: "UserCurrentLocationLatitude")
    }

    
 
}
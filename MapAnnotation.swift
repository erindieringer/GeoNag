//
//  MapAnnotation.swift
//  iOSApp
//
//  Created by Katie Williams on 12/8/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//  Followed tutorial here: http://www.thorntech.com/2016/03/ios-tutorial-make-interactive-slide-menu-swift/
//

import MapKit
import Contacts

class MapAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
    
//    var subtitle: String? {
//        return locationName
//    }
    
    // annotation callout info button opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: title!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}
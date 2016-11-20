//
//  Location.swift
//  iOSApp
//
//  Created by Erin Dieringer on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

struct Location {
    let id: Int
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let name: String
    let phone: String
    let address: String
    let placemark: MKPlacemark
    
}

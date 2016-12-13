//
//  MapViewController.swift
//  iOSApp
//
//  Created by Katie Williams on 12/7/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//  Followed tutorial here: http://www.thorntech.com/2016/03/ios-tutorial-make-interactive-slide-menu-swift/
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // Add Variables to control the Map Menu
    var interactor:Interactor? = nil
    var menuActionDelegate:MenuActionDelegate? = nil
    var coreDataHelper = CoreDataHelper()
    
    @IBOutlet weak var mapView: MKMapView!
    let currentLocation = CurrentLocation()
    
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the Current Location for Map View Controller
        
        // Load AppDelegate Tools
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.restoreLocation()
        
        // Center Map on User's Location
        let userCoords = CLLocation(latitude: appDelegate.currentLocation.latitude, longitude: appDelegate.currentLocation.longitude)
        centerMapOnLocation(userCoords)

        // Assign delegate
        mapView.delegate = self
        
        // Retrieve all items that are nearby
        let ADmapSearchItems = coreDataHelper.fetchRecordsForEntity("SearchItem")
        
        // Add annotation/pin for each item that is nearby
        if let mapSearchItems = ADmapSearchItems as? [SearchItem] {
            var mapAnnotationsArray:[MKAnnotation] = []
            for item in mapSearchItems {
                let title = item.valueForKey("name") as! String
                let latitude = item.valueForKey("latitude") as! CLLocationDegrees
                let longitude = item.valueForKey("longitude") as! CLLocationDegrees
                let mapAnnotation = MapAnnotation(title:title, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                mapAnnotationsArray.append(mapAnnotation)
            }
            mapView.addAnnotations(mapAnnotationsArray)
        } else {
            print("Map Search Items is Nil")
        }
        
    }
    
    // Set a region radius for the map that only considers and shows the neraby pins
    let regionRadius: CLLocationDistance = 300
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 3.0, regionRadius * 3.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Map response to user gestures
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .Left)
        
        MenuHelper.mapGestureStateToInteractor(
            sender.state,
            progress: progress,
            interactor: interactor){
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - close map
    @IBAction func closeMenu(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func delay(seconds seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }
    
    // MARK: - Transition View
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        dismissViewControllerAnimated(true){
            self.delay(seconds: 0.5){
                self.menuActionDelegate?.reopenMenu()
            }
        }
    }

    
    
}
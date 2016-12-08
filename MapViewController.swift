//
//  MapViewController.swift
//  iOSApp
//
//  Created by Katie Williams on 12/7/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit
import MapKit

import UIKit


class MapViewController: UIViewController {
    
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    @IBOutlet weak var mapView: MKMapView!
    let currentLocation = CurrentLocation()
    
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropPins() {
//        let droppedPin = MKPointAnnotation()
//        //droppedPin.coordinate = CLLocationCoordinate2D(latitude: carLocation.latitude, longitude: carLocation.longitude)
//        droppedPin.title = "Your Car"
//        mapView.addAnnotation(droppedPin)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get current location
        currentLocation.getCurrentLocation()
        //let userCoords = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        //centerMapOnLocation(userCoords)
        centerMapOnLocation(initialLocation)
        // drop a pin at current location
        dropPins()
        mapView.delegate = self
        // show artwork on map
        let artwork = Artwork(title: "King David Kalakaua",
                              locationName: "Waikiki Gateway Park",
                              discipline: "Sculpture",
                              coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        
        mapView.addAnnotation(artwork)
    }
    
    let regionRadius: CLLocationDistance = 750
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 3.0, regionRadius * 3.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var interactor:Interactor? = nil
    
    var menuActionDelegate:MenuActionDelegate? = nil
    
    
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
    
    @IBAction func closeMenu(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func delay(seconds seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        dismissViewControllerAnimated(true){
            self.delay(seconds: 0.5){
                self.menuActionDelegate?.reopenMenu()
            }
        }
    }

    
    
}
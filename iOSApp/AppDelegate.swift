//
//  AppDelegate.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//
//  NOTE: our appdelegate is verbose becuase alot of our functionality runs when the app in the background so the functions could not be moved out of the App Delegate

import UIKit
import CoreData
import CoreLocation
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , CLLocationManagerDelegate {
    
    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()
    lazy var tagView = TagView()
    // define core data helper to manage core data objects
    var coreDataHelper = CoreDataHelper()
    var usedTags:[Tag]?
    
    var isExecutingInBackground = false
    
    //to use in mapView
    var mapSearchItems: [NSManagedObject] = []
    
    //location variables
    var locationManager: CLLocationManager! = nil
    var currentLocation = CurrentLocation()
    
    var dataManager = DataManager()
    
    var notificationManager = NotificationManager()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let listViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ListNavVC")
        
        self.window?.rootViewController = listViewController
        
        self.window?.makeKeyAndVisible()
        
        // Initialize tags in the database
        initializeTags()
        
        //LOCATION INIT
        initLocation()
        currentLocation.getCurrentLocation()
        saveLocation()
        
        //Notification INIT
        notificationManager.setupNotificationSettings()
        
        // Modify Views for all pages - change navigation bar color
        changeNavigationBarColor()
        
        return true
        
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        isExecutingInBackground = true

    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        isExecutingInBackground = false

    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreDataStack.saveContext()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification){
        NSNotificationCenter.defaultCenter().postNotificationName("SomeNotification", object:nil)
        print("recieved notification")
    }
    
    // MARK: - Change Navigation View Color
    func changeNavigationBarColor() {
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.tintColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha: 1)
        navigationBarAppearance.barTintColor = UIColor(red:40.0/255.0, green:40.0/255.0, blue:40.0/255.0, alpha: 1.0)
        
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        navigationBarAppearance.frame.origin.y = -20
        navigationBarAppearance.translucent = false;
    }
    
    
    // MARK: - Tag Database Initialization (static)
    func initializeTags() {
        // Initialize default list of tags
        if tagView.tagsExist() == false {
            let tags = tagView.createAllTags()
            tagView.tags = tags
        } else {
            //sets tagView tags to the tags in use
            let tagPredicate = NSPredicate(format:"lists.@count > 0")
            usedTags = tagView.fetchAllTags(tagPredicate)!
            tagView.tags = tagView.fetchAllTags()!
        }
    }
    
    // MARK: - Initialzed all attributes needed for core location
    func initLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 400
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    //When the location is updated in background
    func locationManager( manager: CLLocationManager,
                                    didUpdateLocations locations: [CLLocation]){
        let loc = locations.last!
        let distance = loc.distanceFromLocation(CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
        if (distance > 1500.0){
            // if less than 5 meters per second which is average running speed
            if loc.speed < 5.0 {
                
                //Find items and send notification if any
                setupItemsNotification()
                
                //Reset currentLocation and save
                currentLocation.latitude = loc.coordinate.latitude
                currentLocation.longitude = loc.coordinate.longitude
                saveLocation()
                currentLocation.deleteSearchItems()
            }
            else {
                print("speed too fast")
            }
        }
        else {
            print("not far enough")
        }
    }
    
    //Find matching items based on tags and send notification
    func setupItemsNotification() {
        print("update SIGNIFICANT location")
        currentLocation.deleteSearchItems()
        //Get all tag names in use
        let tags = getListTags()
        
        //get mapkit search for tag string name
        for tag in tags {
            setSearchItems(tag)
        }
        let tagSearchItems = currentLocation.getSearchItems()
        mapSearchItems = tagSearchItems
        
        if (tagSearchItems.count > 0){
            var closest = findClosestItem(tagSearchItems)
            if ((closest == "") || (closest.characters.count == 0)){
                closest = tagSearchItems.last!.valueForKey("name")! as! String
            }
            notificationManager.newNotification(closest)
        }
    }
    
    //Use currentLocation to get the matching items
    func setSearchItems(tag: String) {
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: span)
        currentLocation.findMatchingItems(tag, region: region)
    }
    
    
    // MARK: - Using usedTags list to find names of all tags currently selected across all lists
    func getListTags() -> [String] {
        var tagNames: [String] = []
        if let used = usedTags {
            for tag in used {
                tagNames.append(tag.valueForKey("name") as! String)
            }
        }
        return tagNames
    }
    
    //Location services authorized
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            print("Ready to go!")
        }
    }
    
    // MARK: - Returns name of closest item in itemList to current location
    func findClosestItem(itemList: [NSManagedObject]) -> String {
        var closest = ""
        let currenLat = locationManager.location?.coordinate.latitude
        let currenLong = locationManager.location?.coordinate.longitude
        let currentLoc = CLLocation(latitude: currenLat!, longitude: currenLong!)
        //Hard coding sorry (we know it'll never be greater than 800 becuase radius)
        var min = 5000.0
        for item in itemList{
            let mapItem = item
            let lat = mapItem.valueForKey("latitude") as! Double
            let long = mapItem.valueForKey("longitude") as! Double
            let itemLoc = CLLocation(latitude: lat, longitude: long)
            let distance = currentLoc.distanceFromLocation(itemLoc)
            if (distance < min){
                min = distance
                closest = mapItem.valueForKey("name") as! String
            }
        }
        return closest
    }
    //MARK: - Saving and reloading fron plist
    
    //Saving current location object plist
    func saveLocation() {
        dataManager.location = currentLocation
        dataManager.saveLocation()
    }
    
    //Restores currentLocation object on reload
    func restoreLocation() {
        dataManager.loadLocation()
        currentLocation = dataManager.location
    }
    
    
}


//
//  AppDelegate.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , CLLocationManagerDelegate {
    
    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()
    lazy var tagView = TagView()
    var usedTags:[Tag]?
    
    var currentUser:NSManagedObject?
    var isExecutingInBackground = false
    
    //to use in mapView
    var mapSearchItems: [NSManagedObject] = []
    
    //location variables
    var locationManager: CLLocationManager! = nil
    var currentLocation = CurrentLocation()
    
    var dataManager = DataManager()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let managedObjectContext = coreDataStack.managedObjectContext
        
        // Only open up the login page if the user has never used the app before
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newUserViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("NewUserVC")
        
        let listViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ListNavVC")
        
        
        let user = fetchRecordsForEntity("User", inManagedObjectContext: managedObjectContext)
        print(user)
        
        if let userInfo = user.first {
            print("user exists")
            currentUser = userInfo
            self.window?.rootViewController = listViewController
        } else {
            print("user dne")
            self.window?.rootViewController = newUserViewController
        }
        
        self.window?.makeKeyAndVisible()
        
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

        
        
        // Start up Plist for storing current user location data
        PlistManager.sharedInstance.startPlistManager()
        
        //LOCATION INIT
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.distanceFilter = 1500
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        //To use for real tests
        //locationManager.startMonitoringSignificantLocationChanges()
        let notificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        currentLocation.getCurrentLocation()
        saveData()
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
        print("background")

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
    }
    
    // MARK: - Core Data Method for Creating Records
    
    func createRecordForEntity(entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObject? {
        // Helpers
        var result: NSManagedObject? = nil
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName(entity, inManagedObjectContext: managedObjectContext)
        
        if let entityDescription = entityDescription {
            // Create Managed Object
            result = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
        }
        
        return result
    }
    
    func fetchRecordsForEntity(entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext, predicate:NSPredicate?=nil) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest(entityName: entity)
        if (predicate != nil) {
            fetchRequest.predicate = predicate
        }
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
    
    func locationManager( manager: CLLocationManager,
                                    didUpdateLocations locations: [CLLocation]){
        print("update location")
        restoreData()
        let loc = locations.last!
        let distance = loc.distanceFromLocation(CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
        if (distance > 2000.0){
            /// if less than 5 meters per second which is average running speed
            if loc.speed < 5.0 {
                print("update SIGNIFICANT location")
                deleteSearchItems()
                //Get all tag names in use
                let tags = getListTags()
                //get mapkit search for tag string name
                for tag in tags {
                    setSearchItems(tag)
                }
   
                let tagSearchItems = getSearchItems()
                mapSearchItems = tagSearchItems
                print(tagSearchItems.count)
                if (tagSearchItems.count > 0){
                    // put logic to find closest.. for now do top
                    //let topItem = tagSearchItems.first!.valueForKey("name")! as! String
                    let closest = findClosestItem(tagSearchItems)
                    newNotification(closest)
                }
                //now reset currentLocatoin and save
                currentLocation.latitude = loc.coordinate.latitude
                currentLocation.longitude = loc.coordinate.longitude
                saveData()
//                deleteSearchItems()

            
            }
            else {
                print("speed too fast")
            }
        }
        deleteSearchItems()
        print("after delete count", mapSearchItems.count)
        print(currentLocation.longitude, currentLocation.latitude)
   
    }
    
    func setSearchItems(tag: String) {
        //print("set search")
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: span)
        currentLocation.findMatchingItems(tag, region: region)
    }
    
    // Will return list
    func getSearchItems() -> [NSManagedObject] {
        let managedObjectContext = coreDataStack.managedObjectContext
        let items = fetchRecordsForEntity("SearchItem", inManagedObjectContext: managedObjectContext)
        return items
    }
    
    //Delete all search items from coredata to prepare for setting new ones
    func deleteSearchItems() {
        print("delete")
        let fetchRequest = NSFetchRequest(entityName: "SearchItem")
        let managedObjectContext = coreDataStack.managedObjectContext
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.executeRequest(batchDeleteRequest)
            
        } catch {
            print("error batch delete")
        }
        
    }
    
    func getListTags() -> [String] {
        var tagNames: [String] = []
        if let used = usedTags {
            for tag in used {
                tagNames.append(tag.valueForKey("name") as! String)
            }
        }
        return tagNames
    }
    
    
    //from view controller
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            print("Ready to go!")
        }
    }
    
    func newNotification (name: String) {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        cancelNotifications()
        //print("notif here")
        let locattionnotification = UILocalNotification()
        locattionnotification.category = "locationReminderCategory"
        locattionnotification.alertBody = " \(name) is nearby!"
        locattionnotification.alertAction = "View List"
        locattionnotification.userInfo = ["TYPE":"Page1"]
        UIApplication.sharedApplication().scheduleLocalNotification(locattionnotification)
    }
    
    //cancels all notificaitons so that new ones can be stored
    func cancelNotifications () {
        let app:UIApplication = UIApplication.sharedApplication()
        for oneEvent in app.scheduledLocalNotifications! {
            let notification = oneEvent as UILocalNotification
            app.cancelLocalNotification(notification)
            }
    }
    
    //find closest item to the current location
    func findClosestItem(itemList: [NSManagedObject]) -> String {
        var closest = ""
        //Hard coding sorry (we know it'll never be greater than 800 becuase radius)
        let currenLat = locationManager.location?.coordinate.latitude
        let currenLong = locationManager.location?.coordinate.longitude
        let currentLoc = CLLocation(latitude: currenLat!, longitude: currenLong!)
        var min = 2000.0
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
    
    //saving plist
    func saveData() {
        dataManager.location = currentLocation
        dataManager.saveLocation()
    }
    
    func restoreData() {
        dataManager.loadLocation()
        currentLocation = dataManager.location
    }

    
    
}


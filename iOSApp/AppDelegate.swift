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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , CLLocationManagerDelegate {
    
    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()
    
    var currentUser:NSManagedObject?
    var isExecutingInBackground = false
    
    //location variables
    var locationManager: CLLocationManager! = nil
    var currentLocation = CurrentLocation()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let managedObjectContext = coreDataStack.managedObjectContext
        //        // Helpers
        //        var list: NSManagedObject? = nil
        //
        //        // Fetch List Records
        //        let lists = fetchRecordsForEntity("List", inManagedObjectContext: managedObjectContext)
        //
        //        // Fetch Item Records
        //        let items = fetchRecordsForEntity("Item", inManagedObjectContext: managedObjectContext)
        //
        //        if let listRecord = lists.first {
        //            list = listRecord
        //        } else if let listRecord = createRecordForEntity("List", inManagedObjectContext: managedObjectContext) {
        //            list = listRecord
        //        }
        //
        //        if let list = list {
        //            if list.valueForKey("name") == nil {
        //                list.setValue("Shopping List", forKey: "name")
        //            }
        //
        //            if list.valueForKey("dateCreated") == nil {
        //                list.setValue(NSDate(), forKey: "dateCreated")
        //            }
        //
        //            let items = list.mutableOrderedSetValueForKey("items")
        //
        //            // Create Item Record
        //            if let item = createRecordForEntity("Item", inManagedObjectContext: managedObjectContext) {
        //                // Set Attributes
        //                item.setValue("Item \(items.count + 1)", forKey: "text")
        //
        //                // Set Relationship
        //                item.setValue(list, forKey: "list")
        //
        //                // Add Item to Items
        //                items.addObject(item)
        //            }
        //
        //        }
        //
        //
        //
        //        do {
        //            // Save Managed Object Context
        //            try managedObjectContext.save()
        //
        //        } catch {
        //            print ("\(error)")
        //            print("Unable to save managed object context.")
        //        }
        
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
        
        // Start up Plist for storing current user location data
        PlistManager.sharedInstance.startPlistManager()
        
        //LOCATION INIT
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //To use for real tests
       // locationManager.startMonitoringSignificantLocationChanges()
        let notificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        
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
    
    //does everytime the lcoation is update not changed
//    func locationManager(manager: CLLocationManager,
//                         didUpdateToLocation newLocation: CLLocation,
//                                             fromLocation oldLocation: CLLocation){
//        print("location change")
//        currentLocation.getCurrentLocation()
//        //print(locationManager.location)
//        ///check to see if you've move significantly
//        let old = oldLocation
//        let new  = newLocation
//        let distanceInMeters = old.distanceFromLocation(new)
//        //print(distanceInMeters)
////        if distanceInMeters > 0.0 {
////            newNotification()
////        }
//        // TO DO clear matching items in storage
//        //To DO get new set of matching items based on tags in storage that allow notifications
//        //newNotification()
//    }
    
    func locationManager( manager: CLLocationManager,
                                    didUpdateLocations locations: [CLLocation]){
        print("location change")
        newNotification()
    }
    
    //handels notifications
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print("notification sent")
    }
    //from view controller
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            print("Ready to go!")
        }
    }
    
    func newNotification () {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        cancelNotifications()
        print("notif here")
        let locattionnotification = UILocalNotification()
        locattionnotification.alertBody = "You have changed location to \(locationManager.location)"
        locattionnotification.alertAction = "View List"
        //print(locattionnotification)
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
    
    
}


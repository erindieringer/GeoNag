//
//  AppDelegate.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let managedObjectContext = coreDataStack.managedObjectContext
        
        // Helpers
        var list: NSManagedObject? = nil
        
        // Fetch List Records
        let lists = fetchRecordsForEntity("List", inManagedObjectContext: managedObjectContext)
        
        if let listRecord = lists.first {
            list = listRecord
        } else if let listRecord = createRecordForEntity("List", inManagedObjectContext: managedObjectContext) {
            list = listRecord
        }
        
        print("number of lists: \(lists.count)")
        print("--")
        print(list)

        
        do {
            // Save Managed Object Context
            try managedObjectContext.save()
            
        } catch {
            print ("\(error)")
            print("Unable to save managed object context.")
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
    
    func fetchRecordsForEntity(entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest(entityName: entity)
        
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

}


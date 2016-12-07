//
//  ListDetailViewController.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation


class ListDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate   {
    
    var detailViewModel:ListDetailView?
    var list:List?
    
    // Set up location details
    let locationManager = CLLocationManager()
    var location = CurrentLocation()
    
    @IBAction func addItem(sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Reminder",
                                      message: "Add a new reminder",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveItem(textField!.text!)
                                        self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.view.setNeedsLayout()
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
        
    }
    
    func saveItem(text: String) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.coreDataStack.managedObjectContext
        
        // create new item entity
        let itemEntity = (appDelegate.createRecordForEntity("Item", inManagedObjectContext: managedContext))!
        // set values of new list entity
        itemEntity.setValue(text, forKey: "text")
        itemEntity.setValue((list! as NSManagedObject), forKey: "list")
        
//        let itemPredicate = NSPredicate(format:"list == %@", list!)
//        let items = appDelegate.fetchRecordsForEntity("Item", inManagedObjectContext: managedContext, predicate: itemPredicate)
        detailViewModel!.items.append( itemEntity as! Item )
        print("items after append")
        print(detailViewModel!.items)
        
        // save entity
        appDelegate.coreDataStack.saveContext()
    }
    
    func updateItem(index: Int, text: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        print("items")
        print(detailViewModel!.items)
        print("index")
        print(index)
        
        detailViewModel!.items[index].text = text
        list!.dateModified = NSDate()
        
        appDelegate.coreDataStack.saveContext()
    }
    
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        //TO DO: delete from API
    }
    
    @IBAction func notificationSwitch(sender: AnyObject) {
        //on
        if detailViewModel!.reminderList.notifications == false {
            detailViewModel!.reminderList.notifications = true
        }
            //off
        else {
            detailViewModel!.reminderList.notifications = false
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)  -> Int {
        return detailViewModel!.numberOfRows()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("item", forIndexPath: indexPath)
        cell.textLabel?.text =  detailViewModel!.textForRowAtIndexPath(indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.coreDataStack.managedObjectContext
            
            context.deleteObject(detailViewModel!.items[indexPath.row])
            appDelegate.coreDataStack.saveContext()
            
            detailViewModel!.items.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("now: ")
        print(indexPath.row)
        print("items")
        print(detailViewModel!.items)
        
        // deselect row clicked
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let alert = UIAlertController(title: "Update", message: "Please enter the new text for the item.", preferredStyle: .Alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .Default){(_) in
            let newText = alert.textFields![0]
            print("adter: ")
            print(indexPath.row)
            self.updateItem(indexPath.row, text: newText.text!)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addTextFieldWithConfigurationHandler(nil)
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //location notification
    func locationNotification() {
        print("notif here")
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let locattionnotification = UILocalNotification()
        locattionnotification.alertBody = "You have entered a high risk zone (Crown Range Road) , proceed with caution"
        locattionnotification.regionTriggersOnce = false
        let center = CLLocationCoordinate2DMake(37.33233141, -122.03121860)
        //CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.03121860)
        locattionnotification.region = CLCircularRegion(center: center, radius: 200.0, identifier: "Location1")
        locattionnotification.alertAction = "View List"
        print(locattionnotification)
        UIApplication.sharedApplication().scheduleLocalNotification(locattionnotification)
    }
    
    
    
}

    

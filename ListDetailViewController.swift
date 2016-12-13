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


class ListDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var detailViewModel:ListDetailView?

    // define core data helper to manage core data objects
    var coreDataHelper = CoreDataHelper()
        
    // Set up location details
    let locationManager = CLLocationManager()
    var location = CurrentLocation()

    
    @IBOutlet var label: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Use alert controller to add new items to a list
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
    
    // MARK: - Functions to control CoreData Storage/Fetching of List's Item Entities
    
    // MARK: - Save Item in List
    func saveItem(text: String) {
        if detailViewModel != nil {
            // create new item entity
            let itemEntity = coreDataHelper.createRecordForEntity("Item")!
            // set values of new list entity
            itemEntity.setValue(text, forKey: "text")
            itemEntity.setValue((detailViewModel!.reminderList as NSManagedObject), forKey: "list")
            
            detailViewModel!.items.append( itemEntity as! Item )
        
            // save entity
            coreDataHelper.coreDataStack.saveContext()
        }
    }
    
    // MARK: - Update Item in List
    func updateItem(index: Int, text: String) {
        if detailViewModel != nil {
            detailViewModel!.items[index].text = text
            detailViewModel!.reminderList.dateModified = NSDate()
            
            coreDataHelper.coreDataStack.saveContext()
        }
    }
    
    // MARK: - Switch notifications on or off
    @IBAction func notificationSwitch(sender: AnyObject) {
        if detailViewModel != nil {
            if detailViewModel!.reminderList.notifications == false {
                // on
                detailViewModel!.reminderList.notifications = true
            } else {
                // off
                detailViewModel!.reminderList.notifications = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - On List Detail view appear, load all items for a list
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Find Items for List that was selected if viewmodel is not nil
        if detailViewModel != nil {
            let itemPredicate = NSPredicate(format:"list == %@", (detailViewModel?.reminderList)!)
            detailViewModel!.items = coreDataHelper.fetchRecordsForEntity("Item", predicate: itemPredicate) as! [Item]
        
            label.text = detailViewModel!.title()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Detail Functiosn for Controlling List Detail Tables ... no need for checking optionals because detailViewModel exists once the page has loade as seen on prepareForSegue() in ListViewController.swift
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
            let context = coreDataHelper.coreDataStack.managedObjectContext
            
            context.deleteObject(detailViewModel!.items[indexPath.row])
            coreDataHelper.coreDataStack.saveContext()
            
            detailViewModel!.items.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Add Check marks on row select or unselect for list items
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var text = detailViewModel!.items[indexPath.row].text!
        if text.characters.contains("✔"){
            text = String(text.characters.dropLast())
            text = String(text.characters.dropLast())
        }
        else {
            text = text + " ✔"
        }
        
        self.updateItem(indexPath.row, text: text)
        self.tableView.reloadData()
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Segues to tag view controller always showing
        if let tagVC = segue.destinationViewController as? TagViewController {
            tagVC.listModel = detailViewModel
        }
        // Control for Delete button at button of page
        if segue.identifier == "DeleteItemList"
        {
            let context = coreDataHelper.coreDataStack.managedObjectContext
            
            context.deleteObject(detailViewModel!.reminderList)
            coreDataHelper.coreDataStack.saveContext()
        }
    }
    
    
}

    

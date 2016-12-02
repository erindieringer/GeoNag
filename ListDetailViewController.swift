//
//  ListDetailViewController.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit
import CoreData


class ListDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var viewModel: ListDetailViewModel?
    
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
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.coreDataStack.managedObjectContext
        
        // create new list entity
        //let listEntity = NSEntityDescription.entityForName("List", inManagedObjectContext: managedContext)
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: managedContext) as! Item
        
        // set values of new list entity
        newItem.assignAttributes(appDelegate, text: text, list: viewModel!.reminderList)
        var items = viewModel?.getReminderItems()
        items!.append(newItem)
        viewModel!.reminderList.items = NSOrderedSet(array: items!)
    }

    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        //TO DO: delete from API
    }
    
    @IBAction func notificationSwitch(sender: AnyObject) {
        if viewModel!.reminderList.notifications == false {
            viewModel!.reminderList.notifications = true
        }
        else {
             viewModel!.reminderList.notifications = false
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        return viewModel!.numberOfRows()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reminder_item", forIndexPath: indexPath)
        cell.textLabel?.text =  viewModel!.textForRowAtIndexPath(indexPath)
        return cell
    }
    
}

    

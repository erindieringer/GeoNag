//
//  ListViewController.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    let viewModel = ListViewModel()
    
    var currentUser:User?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addItem(sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Item",
                                      message: "Add a new list",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveList(textField!.text!)
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
    
    func saveList(name: String) {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.coreDataStack.managedObjectContext
        
        // create new list entity
        let listEntity = appDelegate.createRecordForEntity("List", inManagedObjectContext: managedContext)
        
//        //let listEntity = NSEntityDescription.entityForName("List", inManagedObjectContext: managedContext)
//        let newList = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: managedContext) as! List
//        
//      // set values of new list entity
        self.setValue(name, forKey: "name")
        self.setValue(NSDate(), forKey: "dateCreated" )
        self.setValue(NSDate(), forKey: "dateModified")
        self.setValue(0, forKey: "shared")
        self.setValue(1, forKey: "notifications")
        self.setValue(currentUser, forKey: "user")
        self.setValue(NSOrderedSet(), forKey: "items")
        self.setValue(NSOrderedSet(), forKey: "friends")
        // save entity
        appDelegate.coreDataStack.saveContext()
//        newList.assignAttributes(appDelegate, name: name, currentUser: 2)
        viewModel.lists.append(listEntity!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // register the nib
        let cellNib = UINib(nibName: "ListsTableViewCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedRow, animated: true)
        }
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.coreDataStack.managedObjectContext
        
        let user = appDelegate.fetchRecordsForEntity("User", inManagedObjectContext: managedObjectContext)
        
        if let userInfo = user.first {
            let fname = String(userInfo.valueForKey("firstName"))
            let lname = String(userInfo.valueForKey("lastName"))
            let phone = String(userInfo.valueForKey("phoneNumber"))
            currentUser = User(fname, lastName: lname, phoneNumber: phone)
        } else {
            performSegueWithIdentifier("toUserLogin", sender: nil)
        }
        
        viewModel.lists = appDelegate.fetchRecordsForEntity("List", inManagedObjectContext: managedObjectContext)

    }
    
    //Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)  -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListsTableViewCell
        cell.textLabel?.text =  viewModel.titleForRowAtIndexPath(indexPath)
        //cell.summary?.text = viewModel.summaryForRowAtIndexPath(indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("toDetailVC", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailVC = segue.destinationViewController as? ListDetailViewController,
            cell = sender as? UITableViewCell,
            indexPath = tableView.indexPathForCell(cell) {
            detailVC.viewModel =  viewModel.detailViewModelForRowAtIndexPath(indexPath)
        }
    }
    
}
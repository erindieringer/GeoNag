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
    
    let viewModel = ListView()
    
    var currentUser:NSManagedObject?
    
    var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
    var currentRadius:CGFloat = 0.0
    
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
        let listEntity = (appDelegate.createRecordForEntity("List", inManagedObjectContext: managedContext))!
        
        // set values of new list entity
        listEntity.setValue(name, forKey: "name")
        listEntity.setValue(NSDate(), forKey: "dateCreated" )
        listEntity.setValue(NSDate(), forKey: "dateModified")
        listEntity.setValue(0, forKey: "shared")
        listEntity.setValue(1, forKey: "notifications")
        listEntity.setValue(currentUser, forKey: "user")
        listEntity.setValue(NSOrderedSet(), forKey: "items")
        listEntity.setValue(NSOrderedSet(), forKey: "tags" )
        listEntity.setValue(NSOrderedSet(), forKey: "friends")
        viewModel.lists.append(listEntity as! List)
        // save entity
        appDelegate.coreDataStack.saveContext()
        
    }
    
    func updateList(index: Int, name: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        viewModel.lists[index].name = name
        viewModel.lists[index].dateModified = NSDate()

        appDelegate.coreDataStack.saveContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // register the nib
        let cellNib = UINib(nibName: "ListsTableViewCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "list")
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
            currentUser = userInfo
        }
        
        let listPredicate = NSPredicate(format:"user == %@", currentUser!)
        viewModel.lists = appDelegate.fetchRecordsForEntity("List", inManagedObjectContext: managedObjectContext, predicate: listPredicate) as! [List]

    }
    
    //Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)  -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("list", forIndexPath: indexPath) as! ListsTableViewCell
        cell.textLabel?.text =  viewModel.titleForRowAtIndexPath(indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("toDetailVC", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.coreDataStack.managedObjectContext

            context.deleteObject(viewModel.lists[indexPath.row])
            appDelegate.coreDataStack.saveContext()
            
            viewModel.lists.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailVC = segue.destinationViewController as? ListDetailViewController,
            indexPath = sender as? NSIndexPath {
            detailVC.detailViewModel =  viewModel.detailViewModelForRowAtIndexPath(indexPath)
            detailVC.detailViewModel!.reminderList = (viewModel.getListForIndexPath(indexPath) as? List)!
        }
    }
    
}
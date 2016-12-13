//
//  ListViewController.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit
import CoreData

// Protocol for menu actions for map view
protocol MenuActionDelegate {
    func openSegue(segueName: String, sender: AnyObject?)
    func reopenMenu()
}

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    let viewModel = ListView()
    
    // define core data helper to manage core data objects
    var coreDataHelper = CoreDataHelper()
    
    // For Pan View
    let interactor = Interactor()
    
    @IBOutlet weak var tableView: UITableView!
    
    // Clicking map icon opens menu
    @IBAction func openMenu(sender: AnyObject) {
        performSegueWithIdentifier("openMenu", sender: nil)
    }
    
    // gestures to open menu
    @IBAction func edgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translationInView(view)
        
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .Right)
        
        MenuHelper.mapGestureStateToInteractor(
            sender.state,
            progress: progress,
            interactor: interactor){
                self.performSegueWithIdentifier("openMenu", sender: nil)
        }
    }
    
    // MARK: - Add Lists in Main View
    @IBAction func addItem(sender: AnyObject) {
        
        // create alert controller to help add a new list
        
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
    
    // MARK: - Save List After Adding New One
    func saveList(name: String) {
        // create new list entity
        let listEntity = (coreDataHelper.createRecordForEntity("List"))!
        
        // set values of new list entity
        listEntity.setValue(name, forKey: "name")
        listEntity.setValue(NSDate(), forKey: "dateCreated" )
        listEntity.setValue(NSDate(), forKey: "dateModified")
        listEntity.setValue(0, forKey: "shared")
        listEntity.setValue(1, forKey: "notifications")
        listEntity.setValue(NSOrderedSet(), forKey: "items")
        listEntity.setValue(NSOrderedSet(), forKey: "tags" )
        listEntity.setValue(NSOrderedSet(), forKey: "friends")
        viewModel.lists.insert(listEntity as! List, atIndex:0)
        
        // save entity
        coreDataHelper.coreDataStack.saveContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // register the nib
        let cellNib = UINib(nibName: "ListsTableViewCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "list")
        // Open Map on notification click
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(ListViewController.SomeNotificationAct(_:)),
                                                         name: "SomeNotification",
                                                         object: nil)
    }
    
    // MARK: - Function to transfer notification click to mapmenu
    func SomeNotificationAct(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("openMenu", sender: self)
        }
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
        
        // sort lists by date modified
        let sortDescriptor = NSSortDescriptor(key: "dateModified", ascending: false)
        if let lists = coreDataHelper.fetchRecordsForEntity("List", sortDescriptor: sortDescriptor) as? [List] {
            viewModel.lists = lists
        }
    }
    
    // MARK: - Table View Functions to control Table view and Selection in Main List Page
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
        // Slide left to make Delete Button Appear
        if editingStyle == .Delete {
            // Delete list if button pushed
            let context = coreDataHelper.coreDataStack.managedObjectContext
            
            context.deleteObject(viewModel.lists[indexPath.row])
            coreDataHelper.coreDataStack.saveContext()
            
            viewModel.lists.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Segues to List View
        if let detailVC = segue.destinationViewController as? ListDetailViewController,
            indexPath = sender as? NSIndexPath {
            detailVC.detailViewModel =  viewModel.detailViewModelForRowAtIndexPath(indexPath)
            if let list = viewModel.getListForIndexPath(indexPath) as? List {
                if detailVC.detailViewModel != nil {
                    detailVC.detailViewModel!.reminderList = list
                }
            }
        }
        // Segue to Map View
        if let mapVC = segue.destinationViewController as? MapViewController {
            mapVC.transitioningDelegate = self
            mapVC.interactor = interactor
            mapVC.menuActionDelegate = self
        }
    }
    
}
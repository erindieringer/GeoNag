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
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = [NSManagedObject]()
    
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
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
        
    }
    
    func saveList(name: String) {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // create new list entity
        let listEntity = NSEntityDescription.entityForName("List", inManagedObjectContext: managedContext)
        let newList = List(entity: listEntity!, insertIntoManagedObjectContext: managedContext)
        
        // set values of new list entity
        newList.assignAttributes(appDelegate, name: <#T##String#>)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Lists"
        tableView.registerClass(UITableViewCell.self,
                                forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        if let selectedRow = tableView.indexPathForSelectedRow {
//            tableView.deselectRowAtIndexPath(selectedRow, animated: true)
//        }
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "List")
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            items = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

    }
    
    //Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)  -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text =  viewModel.titleForRowAtIndexPath(indexPath)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailVC = segue.destinationViewController as? ListDetailViewController,
            cell = sender as? UITableViewCell,
            indexPath = tableView.indexPathForCell(cell) {
            detailVC.viewModel =  viewModel.detailViewModelForRowAtIndexPath(indexPath)
        }
    }
    
}
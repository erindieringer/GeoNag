//
//  ListDetailViewController.swift
//  iOSApp
//
//  Created by Katie Williams on 11/18/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit

class ListDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var viewModel: ListDetailViewModel?
    
    
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

    

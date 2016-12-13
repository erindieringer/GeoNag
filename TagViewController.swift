//
//  TagViewController.swift
//  iOSApp
//
//  Created by Katie Williams on 12/6/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit

class TagViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Variables to Access Tag Info
    var tagView:TagView?
    var listModel:ListDetailView?
    // selected tag img files
    var tagImages:NSArray = ["groceries.png", "convenience.png", "drug", "post.png", "bank", "beverage.png", "home.png", "sports.png"]
    // unselected tag img files
    var oTagImages:NSArray = ["ogroceries.png", "oconvenience.png", "odrug", "opost.png", "obank", "obeverage.png", "ohome.png", "osports.png"]
    
    // reuse id of tag collection cells
    let reuseIdentifier = "cell"
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagView!.numberOfTags
    }
    
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to the storyboard cell ids
        let reuseIDs = ["cellGroceries", "cellConvenience", "cellDrug", "cellPost", "cellBank", "cellBeverage", "cellHome", "cellSports"]
        let reuseID = reuseIDs[indexPath.row]
        let cellRef = collectionView.dequeueReusableCellWithReuseIdentifier(reuseID, forIndexPath: indexPath) as! TagCollectionViewCell
   
        // use cell for actual cell styles
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if cell?.selected == true {
            let tag = tagView!.tags[indexPath.row]
            let currTagsForList = listModel?.getTags()
            if (currTagsForList?.contains(tag) == true) {
                let tagImageView = (cell!.viewWithTag(100)! as! UIImageView)
                // if the tag is not selected, make it normal tag image
                tagImageView.image = UIImage(named: tagImages[indexPath.row] as! String)
                listModel?.deleteTag(tag)
            } else {
                // if tag is selected, make it opaque tag image
                let tagImageView = (cell!.viewWithTag(100)! as! UIImageView)
                tagImageView.image = UIImage(named: oTagImages[indexPath.row] as! String)
                listModel?.addTag(tag)
            }
        }
        
        return cellRef
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if cell?.selected == true {
            let tag = tagView!.tags[indexPath.item]
            let currTagsForList = listModel?.getTags()
            if (currTagsForList?.contains(tag) == true) {
                let tagImageView = (cell!.viewWithTag(100)! as! UIImageView)
                // if the tag is not selected, make it normal tag image
                tagImageView.image = UIImage(named: tagImages[indexPath.row] as! String)
                listModel?.deleteTag(tag)
            } else {
                let tagImageView = (cell!.viewWithTag(100)! as! UIImageView)
                // if tag is selected, make it opaque tag image
                tagImageView.image = UIImage(named: oTagImages[indexPath.row] as! String)
                listModel?.addTag(tag)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Assign
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        tagView = appDelegate.tagView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

}

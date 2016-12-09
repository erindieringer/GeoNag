//
//  TagViewController.swift
//  iOSApp
//
//  Created by Katie Williams on 12/6/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit

class TagViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var tagView:TagView?
    var tags:[Tag]?
    var listModel:ListDetailView?
    var tagImages:NSArray?
    var oTagImages:NSArray?
    
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagView!.numberOfTags
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        // get a reference to our storyboard cell
        let reuseIDs = ["cellGroceries", "cellConvenience", "cellDrug", "cellPost", "cellBank", "cellBeverage", "cellHome", "cellSports"]
        let reuseID = reuseIDs[indexPath.row]
        let cellRef = collectionView.dequeueReusableCellWithReuseIdentifier(reuseID, forIndexPath: indexPath) as! TagCollectionViewCell
        
        // use cell for actual cell styles
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if cell?.selected == true {
            let tag = tagView!.tags[indexPath.item]
            let currTagsForList = listModel?.getTags()
            if (currTagsForList?.contains(tag) == true) {
                let tagImageView = (cell!.viewWithTag(100)! as! UIImageView)
                tagImageView.image = UIImage(named: tagImages![indexPath.row] as! String)
                listModel?.deleteTag(tag)
            } else {
                let tagImageView = (cell!.viewWithTag(100)! as! UIImageView)
                tagImageView.image = UIImage(named: oTagImages![indexPath.row] as! String)
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
                tagImageView.image = UIImage(named: tagImages![indexPath.row] as! String)
                listModel?.deleteTag(tag)
            } else {
                let tagImageView = (cell!.viewWithTag(100)! as! UIImageView)
                tagImageView.image = UIImage(named: oTagImages![indexPath.row] as! String)
                listModel?.addTag(tag)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        tagView = appDelegate.tagView
        tagImages = ["groceries.png", "convenience.png", "drug", "post.png", "bank", "beverage.png", "home.png", "sports.png"]
        oTagImages = ["ogroceries.png", "oconvenience.png", "odrug", "opost.png", "obank", "obeverage.png", "ohome.png", "osports.png"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

}

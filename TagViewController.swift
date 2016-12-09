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
//    var tagImages = ["groceries.png", "convenience.png", "drugstores.png", "post.png", "banks.png", "beverage.png", "home.png", "sports.png"]
    var tagImages:NSArray?
    
//    var selectedPhotos = [FlickrPhoto]()
//    let shareTextLabel = UILabel()
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagView!.numberOfTags
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //let tags = tagView!.fetchAllTags()
        
        // get a reference to our storyboard cell
        let cellRef = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TagCollectionViewCell
        
//        let tagImageView = (cellRef.viewWithTag(100)! as! UIImageView)
//        print(tagImages)
//        tagImageView.image = UIImage(named: tagImages![indexPath.row] as! String)
//        self.view.addSubview(recipeImageView)
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cellRef.label.text = tagView!.tags[indexPath.item].name
        
        // use cell for actual cell styles
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if cell?.selected == true {
            cell?.backgroundColor = UIColor.orangeColor()
        } else {
            cell?.backgroundColor = UIColor.clearColor()
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
                cell?.backgroundColor = UIColor(red: 193.0/255.0, green: 206.0/255.0, blue: 202.0/255.0, alpha: 1.0)
                listModel?.deleteTag(tag)
            } else {
                cell?.backgroundColor = UIColor(red: 149.0/255.0, green: 158.0/255.0, blue: 156.0/255.0, alpha: 1.0)
                listModel?.addTag(tag)
            }
        } else {
            cell?.backgroundColor = UIColor.blueColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        tagView = appDelegate.tagView
        tagImages = ["groceries.png", "convenience.png", "drug", "post.png", "bank", "beverage.png", "home.png", "sports.png"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

}

//
//  TagViewController.swift
//  iOSApp
//
//  Created by Katie Williams on 12/6/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import UIKit

class TagViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var tagView = TagView()
    var tags:[Tag]?
    
//    var selectedPhotos = [FlickrPhoto]()
//    let shareTextLabel = UILabel()
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagView.numberOfTags
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get tags
        if let tagsStored = tagView.fetchAllTags() {
            if tagsStored.first != nil {
                tags = tagsStored
            }
        } else {
            tags = tagView.createAllTags()
        }
        
        // get a reference to our storyboard cell
        let cellRef = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TagCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cellRef.label.text = tags![indexPath.item].name
        
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
            cell?.backgroundColor = UIColor.orangeColor()
        } else {
            cell?.backgroundColor = UIColor.clearColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if tagView.tags.count < 8 {
            tagView.createAllTags()
        }
        tags = tagView.tags
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

}

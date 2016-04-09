//
//  FeatureCollectionViewController.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/28/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

@objc protocol FeatureHandler{
    func quitFeatures()
}

class FeatureCollectionViewController: UICollectionViewController{
    
    
    struct FeatureConstants{
        static let CollectionReusableView = "Collection Cell"
        static let IndexMethod = "/pages/mobileindex"
        static let PageSegue = "Page Segue"
    }
    
    var feature:Feature?
    var pages = [Page]()
    var images = [String:String]()
    var sharedContext: NSManagedObjectContext {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.managedObjectContext
    }
    var image = ""
    var selectedIndex = -1
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        if self.feature != nil{
            self.title = self.feature!.name!
        }
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        getPages()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(FeatureHandler.quitFeatures))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }

    func quitFeatures(){
        self.navigationController?.dismissViewControllerAnimated(false, completion: nil)
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == FeatureConstants.PageSegue{
            if let pvc = segue.destinationViewController as? PageViewController{
                if selectedIndex != -1{
                    let page = pages[selectedIndex]
                    pvc.page = page
                    if let key = self.images[pages[selectedIndex].user!]{
                        pvc.image = key
                    }
                }
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.pages.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(FeatureConstants.CollectionReusableView, forIndexPath: indexPath) as! PageCollectionViewCell
    
        cell.page = pages[indexPath.row]
        
        if let key = self.images[pages[indexPath.row].user!]{
            cell.image = key
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */


    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        selectedIndex = indexPath.row
        performSegueWithIdentifier(FeatureConstants.PageSegue, sender: nil)
        return true
    }
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    func getPages(){
        var params = [String:AnyObject]()
        params["offset"] = pages.count
        params["safekey"] = self.feature!.user
        ServerDB.sharedInstance().httpGet(FeatureConstants.IndexMethod, parameters: params, completionHandlerForGET: { [unowned self](data,error) in
            if let results = data as? [String:AnyObject]{
                let result = results["Result"] as! String
                if result == "Success"{
                    let tempImages = results["Images"] as? Array<String>
                    if let tempPages = results["Pages"] as? Array<AnyObject>{
                        var j = 0
                        for i in tempPages{
                            let collection:AnyObject? = i
                            let tempDict = collection as! Dictionary<String,AnyObject>
                            let page = Page.init(dictionary: tempDict, context: self.sharedContext)
                            self.pages.append(page)
                            if tempImages != nil && page.user != nil{
                                self.images[page.user!] = tempImages![j]
                            }
                            j+=1
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.updateUI()
                    })
                }
            }
            
        })
    }
    
    func updateUI(){
        self.collectionView?.reloadData()
    }

}

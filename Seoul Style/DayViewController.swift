//
//  DayViewController.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/27/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit
import CoreData

@objc protocol DayHandler{
    func quitController()
    func swipeLeft(sender:UISwipeGestureRecognizer)
    func swipeRight(sender:UISwipeGestureRecognizer)
}

class DayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    struct DayConstants{
        static let ViewMethod = "/days/mobileview"
        static let FeatureSegue = "Feature Segue"
        static let CellReuseIdentifier = "Feature Cell"
    }
    
    @IBOutlet var loadingView: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!{
        didSet{
            tableView!.dataSource = self
            tableView!.delegate = self
        }
    }
    
    
    
    var sharedContext: NSManagedObjectContext {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.managedObjectContext
    }
    var gender:Int = 2
    var day:Day?
    var features = [Feature]()
    var images = [String]()
    var current = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
                self.title = "Men's Clothes"
   
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(DayHandler.quitController))
        
   
        
        loadingView.startAnimating()
        getDay()
      
        let otherRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(DayHandler.swipeRight))
        otherRecognizer.direction = .Right
        self.view.addGestureRecognizer(otherRecognizer)
    }
    
    


    @IBAction func buttonClicked(sender: UIButton) {
        
        if self.features.count > 0 {
            performSegueWithIdentifier(DayConstants.FeatureSegue, sender: sender)
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func quitController(){
        self.navigationController?.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func getDay(){
        var params = [String:AnyObject]()
        params["gender"] = gender
        
        ServerDB.sharedInstance().httpGet(DayConstants.ViewMethod, parameters: params, completionHandlerForGET: {[unowned self](data,error) in
            if let results = data as? [String:AnyObject]{
                let result = results["Result"] as! String
                if result == "Success"{
                    let dictionary = results["Day"] as! Dictionary<String,AnyObject>
                    self.day = Day.init(dictionary: dictionary, context: self.sharedContext)
                    self.images = results["Images"] as! Array<String>
                    if let tempFeatures = results["Features"] as? Array<AnyObject>{
                        for i in tempFeatures{
                            let collection:AnyObject? = i
                            let tempDict = collection as! Dictionary<String,AnyObject>
                            let feature = Feature.init(dictionary: tempDict, context: self.sharedContext)
                            self.features.append(feature)
                        }
                    }
                }else{
                    
                }
                //update the UI
                dispatch_async(dispatch_get_main_queue(), {
                    self.updateUI()
                })
            }
        })
    }
    

    
    func updateUI(){
        self.loadingView.stopAnimating()
        self.loadingView.hidden = true
        self.tableView.reloadData()
    }

 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == DayConstants.FeatureSegue {
            if let fvc = segue.destinationViewController.contentViewController as? FeatureCollectionViewController {
                fvc.feature = features[current]
            }
        }
    }
    
    // MARK : Table Data Source Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.features.count
    }
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(DayConstants.CellReuseIdentifier, forIndexPath: indexPath) as! FeatureTableViewCell
        let feature = self.features[indexPath.row]
        cell.feature = feature
        if images[indexPath.row] != ""{
            if let decodedData = NSData(base64EncodedString: images[indexPath.row], options: .IgnoreUnknownCharacters){
                print("You've decoded the image in cell")
                if let decodedimage = UIImage(data: decodedData){
                    cell.featureImage = decodedimage
                }
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        current = indexPath.row
        performSegueWithIdentifier(DayConstants.FeatureSegue, sender: nil)
    }


}

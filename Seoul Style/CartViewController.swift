//
//  CartViewController.swift
//  Seoul Style
//
//  Created by Nicholas Park on 4/7/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit
import CoreData

@objc protocol CartHandler{

}

class CartViewController: UIViewController {

    struct CartConstants{
        static let QuickCartMethod = "/carts/quickcart"
    }
    
    var sharedContext: NSManagedObjectContext {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.managedObjectContext
    }
    var cart:Cart?
    var session:String?
    var sessionObserver: NSObjectProtocol?
    
    @IBOutlet var tableView: UITableView!{
        didSet{
            print("Table view has been set")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        let appDelegate = UIApplication.sharedApplication().delegate
        let delegate = appDelegate as! AppDelegate
        delegate.getSession()
        
        sessionObserver = center.addObserverForName(SessionConstants.SessionNotification, object: appDelegate, queue: queue, usingBlock: {notification -> Void in
            self.session = notification.userInfo?[SessionConstants.SessionNotificationKeyName] as? String
            if self.session != nil{
                self.getCart()
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    
    func getCart(){
        var params = [String:AnyObject]()
        params["token"] = self.session
        ServerDB.sharedInstance().httpGet(CartConstants.QuickCartMethod, parameters: params, completionHandlerForGET: {(data,error) in
            if let results = data as? [String:AnyObject]{
                if let result = results["Result"] as? String{
                    if result == "Success"{
                        if let tempDictionary = results["Cart"] as? Dictionary<String,AnyObject>{
                            self.cart = Cart.init(dictionary: tempDictionary, context: self.sharedContext)
                            dispatch_async(dispatch_get_main_queue(), {
                                self.title = "Cart"
                            })
                        }
                    }else if result == "Partial"{
                        //You have no cart!
                    }else{
                        
                    }
                }
                print("The data looks like \(data)")
            }
        })
    }
    
    func getCartItems(){
        
    }

}

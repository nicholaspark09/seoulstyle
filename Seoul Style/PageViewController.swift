//
//  PageViewController.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/29/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit
import CoreData

class PageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    struct Constants{
        static let ViewMethod = "/pages/mobileview"
        static let CellReuseIdentifier = "PageProduct Cell"
        static let ThumbMethod = "/products/profilethumb"
        static let ProductSegue = "Product Segue"
    }
    
    @IBOutlet var tableView: UITableView!
    var images = [String:UIImage]()
    @IBOutlet var roundView: UIView!{
        didSet{
            roundView!.layer.cornerRadius = 5.0
        }
    }
    var image = ""{
        didSet{
            if image != ""{
                if let decodedData = NSData(base64EncodedString: image, options: .IgnoreUnknownCharacters){
                    if let decodedimage = UIImage(data: decodedData){
                        self.imageView?.image = decodedimage as UIImage
                        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
                    }
                }
                if self.imageView == nil{
                    print("IMage View wasn't set")
                }
            }
        }
    }
    

    @IBOutlet var pageLabel: UILabel!
    var largeImage = ""
    var page:Page?
    var pageProducts = [PageProduct]()
    @IBOutlet var imageView: UIImageView!
    var sharedContext: NSManagedObjectContext {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.managedObjectContext
    }
    
    
    @IBOutlet var loadingView: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if image != ""{
            print("Found an image with url: \(image)")
            if let decodedData = NSData(base64EncodedString: image, options: .IgnoreUnknownCharacters){
                if let decodedimage = UIImage(data: decodedData){
                    self.imageView?.image = decodedimage as UIImage
                    self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
                }
            }
            if self.imageView == nil{
                print("IMage View wasn't set")
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
       // self.tableView.registerClass(PageProductTableViewCell.self, forCellReuseIdentifier: Constants.CellReuseIdentifier)
        getPage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func addProducts(){
        self.tableView.reloadData()
    }
    
    /*func addProducts(){
        print("you're operating here")
        for i in pageProducts{
            let product = i
            print("The product name is \(product.name)")
            if product.info != nil && product.info != ""{
                do{
                    let data = product.info!.dataUsingEncoding(NSUTF8StringEncoding)
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    if let coords = json as? [String: AnyObject] {
                        if let x = coords["x"] as? Float32{
                            let y = coords["y"] as? Float32
                            print("x was \(x)")
                            
                            self.addProduct(x,yratio:y!,product:product)
                            
                        }
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                }
            }
            
        }
    }*/
    
    func addProduct(xratio: Float32, yratio: Float32, product: PageProduct){
        let imageWidth = self.imageView.bounds.size.width
        let imageHeight = self.imageView.bounds.size.height
        let leftMargin = imageWidth * CGFloat(xratio)
        let topMargin = imageHeight * CGFloat(yratio)
        let rect = CGRectMake(leftMargin, topMargin, 30, 30)
        let button = UIButton(frame: rect)
        button.setTitle("View", forState: .Normal)
        button.backgroundColor = UIColor.blackColor()
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.imageView.addSubview(button)
    }
    
    func getPage(){
            self.loadingView.hidden = false
            self.loadingView.startAnimating()
            var params = [String:AnyObject]()
            params["safekey"] = page!.user!
            ServerDB.sharedInstance().httpGet(Constants.ViewMethod, parameters: params, completionHandlerForGET: {[unowned self](data,error) in
                if let results = data as? [String:AnyObject]{
                    let result = results["Result"] as! String
                    if result == "Success"{
                        let dictionary = results["Page"] as! Dictionary<String,AnyObject>
                        print("The page was \(dictionary)")
                        self.page = Page.init(dictionary: dictionary, context: self.sharedContext)
                        self.largeImage = results["Image"] as! String
                        
                        if let tempProducts = results["Products"] as? Array<AnyObject>{
                            for i in tempProducts{
                                let collection:AnyObject? = i
                                let tempDict = collection as! Dictionary<String,AnyObject>
                                let pageProduct = PageProduct.init(dictionary: tempDict, context: self.sharedContext)
                                self.pageProducts.append(pageProduct)
                                
                            }
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            if let decodedData = NSData(base64EncodedString: self.largeImage, options: .IgnoreUnknownCharacters){
                                if let decodedimage = UIImage(data: decodedData){
                                    self.image = ""
                                    self.imageView?.image = decodedimage as UIImage
                                    self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
                                }
                            }
                            self.loadingView.stopAnimating()
                            self.loadingView.hidden = true
                            self.addProducts()
                        })
                        
                    }
                }
            
                //print("The data was \(data)")
            })
    }
    

    
  
        // MARK: - Table view data source
            
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return pageProducts.count
        }
        
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellReuseIdentifier, forIndexPath: indexPath) as! PageProductTableViewCell
            let product = pageProducts[indexPath.row]
            cell.pageProduct = product
           // cell.textLabel?.text = pageProducts[indexPath.row].name!
            if images[product.product!] != nil{
                print("Apparently it isn't nil?")
                dispatch_async(dispatch_get_main_queue(), {
                    cell.productImageView.image = self.images[product.product!]
                    cell.productImageView.contentMode = UIViewContentMode.ScaleAspectFit
                    self.tableView.layoutSubviews()
                })
            }else{
                //Gotta load it manually

                var params = [String:AnyObject]()
                params["product"] = product.product!
                ServerDB.sharedInstance().httpGet(Constants.ThumbMethod, parameters: params, completionHandlerForGET: {[unowned self](data,error) in
                    if let results = data as? [String:String]{
                        let result = results["Result"]
                        if result == "Success"{
                            let body = results["Body"]
                            if body != ""{

                                //Create an image from the data
                                if let decodedData = NSData(base64EncodedString: body!, options: .IgnoreUnknownCharacters){
                                    if let decodedimage = UIImage(data: decodedData){
                                        self.images[product.product!] = decodedimage
                                        dispatch_async(dispatch_get_main_queue(), {
                                            cell.productImageView.image = decodedimage
                                            cell.productImageView.contentMode = UIViewContentMode.ScaleAspectFit
                                            self.tableView.layoutSubviews()
                                        })
                                    }
                                }
                            }
                            
                        }
                    }
            
                })
            }
            
            return cell
        }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){

            //let product = pageProducts[indexPath.row]
        /*
        if product.info != nil && product.info != ""{
            do{
                let data = product.info!.dataUsingEncoding(NSUTF8StringEncoding)
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                if let coords = json as? [String: AnyObject] {
                    if let x = coords["x"] as? Float32{
                        let y = coords["y"] as? Float32
                        print("x was \(x)")
                        
                        self.addProduct(x,yratio:y!,product:product)
                        
                    }
                }
            } catch {
                print("error serializing JSON: \(error)")
            }
        }
        */
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.ProductSegue{
            print("You should be in this section")
            if let pvc = segue.destinationViewController.contentViewController as? ProductViewController{
                let product = pageProducts[tableView.indexPathForSelectedRow!.row]
                print("you should be sending this \(product.name)")
                pvc.name = product.name!
                pvc.safekey = product.product!
            }
        }
    }
    

}



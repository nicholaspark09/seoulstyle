//
//  ProductViewController.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/31/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit
import CoreData

@objc protocol ProductHandler{
    func quitProduct()
    func viewCart()
    func tapOut()
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide(notification: NSNotification)
}

class ProductViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    struct Constants{
        static let ViewMethod = "/products/mobileview"
        static let CountryKey = "UserCountry"
        static let CountMethod = "/itemcounts/search"
        static let QuickCartMethod = "/carts/quickcart"
        static let RemoveLabel = "Remove"
        static let AddLabel = "Add to Cart"
        static let AddItemMethod = "/cartitems/mobileadd"
    }
    
    var product:Product?
    var smallImage:UIImage?
    var largeImage:UIImage?
    var safekey:String?
    var name:String?
    var imageData:String?
    var sharedContext: NSManagedObjectContext {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.managedObjectContext
    }
    var sizes = [AttributeValue]()
    var bought:Bool = false
    var country = "US"
    var styles = [Style]()
    var price:ProductPrice?
    var itemcount: ItemCount?
    var pickedSize: AttributeValue?
    var pickedColor: Style?
    var buyable = false
    var session: String?
    var sessionObserver: NSObjectProtocol?
    var cart:Cart?
    var label:UILabel?
    
    
    //All my outlets!
    @IBOutlet var textField: UITextField!
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var sizeSpinner: UIPickerView!{
        didSet{
            sizeSpinner.dataSource = self
            sizeSpinner.delegate = self
        }
    }
    @IBOutlet var colorSpinner: UIPickerView!{
        didSet{
            colorSpinner.dataSource = self
            colorSpinner.delegate = self
        }
    }
    

    @IBOutlet var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if name != nil{
            self.title = name!
        }
        if smallImage != nil{
            profileImage?.image = smallImage!
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(ProductHandler.quitProduct))
        self.firstLabel.text = "Loading..."
        getCountry()
        getProduct()
        
        let image = UIImage(named: "commerce")
        let cartButton = UIButton(frame: CGRect(x: 0, y: 0, width: 53, height: 31))
        cartButton.setImage(image, forState: .Normal)
        cartButton.addTarget(self, action: #selector(ProductHandler.viewCart), forControlEvents: UIControlEvents.TouchUpInside)
        //Add a label to the bar button item
        self.label = UILabel(frame: CGRect(x: 15, y: 5, width: 50, height: 20))
        self.label!.text = "0"
        self.label!.textAlignment = .Center
        self.label!.backgroundColor = UIColor.clearColor()
        cartButton.addSubview(self.label!)
        let barButton = UIBarButtonItem(customView: cartButton)
        self.navigationItem.rightBarButtonItem = barButton
        //let cartButton = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(ProductHandler.viewCart))
      
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProductHandler.tapOut))
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProductHandler.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProductHandler.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        let appDelegate = UIApplication.sharedApplication().delegate
        
        sessionObserver = center.addObserverForName(SessionConstants.SessionNotification, object: appDelegate, queue: queue) {notification -> Void in
            if let sessionKey = notification.userInfo?[SessionConstants.SessionNotificationKeyName] as? String {
                print("You detected the session in products as: \(sessionKey)")
                self.session = sessionKey
                self.getCart()
            }
        }
        let delegate = appDelegate as! AppDelegate
        delegate.getSession()
       
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(sessionObserver!)
        super.viewWillDisappear(animated)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func tapOut(){
        view.endEditing(true)
    }
    
    func getCountry(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let savedCountry = userDefaults.objectForKey(Constants.CountryKey) as? String {
            country = savedCountry
        }else{
            if let temp = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String{
                country = temp
            }
        }
    }
    
    func viewCart(){
        
    }
    
    func quitProduct(){
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var addToCartButton: UIButton!

    //Add to cart clicked, add to the
    @IBAction func addClicked(sender: AnyObject) {
        if buyable {
            bought = !bought
            if bought{
                addToCart()
                /*
                addToCartButton.backgroundColor = UIColor.greenColor()
                addToCartButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                addToCartButton.setTitle(Constants.RemoveLabel, forState: .Normal)
                */
            }else{
                addToCartButton.backgroundColor = UIColor.blueColor()
                addToCartButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                addToCartButton.setTitle(Constants.AddLabel, forState: .Normal)
            }
        }
    }
    
    
    func updateUI(){
        if product != nil{
            self.firstLabel.text = ""
            if imageData != nil && imageData != ""{
                if let decodedData = NSData(base64EncodedString: imageData!, options: .IgnoreUnknownCharacters){
                    if let decodedimage = UIImage(data: decodedData){
                        self.profileImage.image = decodedimage
                        self.profileImage.contentMode = UIViewContentMode.ScaleAspectFit
                        self.largeImage = decodedimage
                    }
                }
            }
        }
        if sizes.count > 0{
            self.sizeSpinner.reloadAllComponents()
        }
        if styles.count > 0 {
            self.colorSpinner.reloadAllComponents()
        }
        if self.price != nil{
            self.priceLabel.text = "\(self.price!.price!) \(self.price!.currency!)"
        }
    }
    
    func addToCart(){
        let number = Int(self.textField.text!)
        if self.session != nil && pickedSize != nil && pickedColor != nil{
            var params = [String:AnyObject]()
            params["token"] = self.session!
            params["safekey"] = pickedColor!.user!
            params["attributevalue"] = pickedSize!.user!
            params["info"] = self.product!.info
            params["name"] = self.product!.name
            params["price"] = self.price!.user!
            params["number"] = number
            ServerDB.sharedInstance().httpPost(Constants.AddItemMethod, parameters: params, jsonBody: "", completionHandlerForPOST: {(data,error) in
                if let results = data as? [String:AnyObject]{
                    if let result = results["Result"] as? String{
                       if result == "Success"{
                            self.getCart()
                       }
                    }
                }
                 print("The data was \(data)")
            })
        }
        
    }
    
    func getCart(){
        var params = [String:AnyObject]()
        params["token"] = self.session
        ServerDB.sharedInstance().httpGet(Constants.QuickCartMethod, parameters: params, completionHandlerForGET: {(data,error) in
            if let results = data as? [String:AnyObject]{
                if let result = results["Result"] as? String{
                    if result == "Success"{
                        if let tempDictionary = results["Cart"] as? Dictionary<String,AnyObject>{
                            self.cart = Cart.init(dictionary: tempDictionary, context: self.sharedContext)
                            dispatch_async(dispatch_get_main_queue(),{
                                self.label!.text = "\(self.cart!.items!)"
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
    
   
    func getProduct(){
        var params = [String:AnyObject]()
        params["safekey"] = safekey!
        params["country"] = country
        ServerDB.sharedInstance().httpGet(Constants.ViewMethod, parameters: params, completionHandlerForGET: {
        [unowned self](data,error) in
            if let results = data as? [String:AnyObject]{
                if let result = results["Result"] as? String{
                    if result == "Success"{
                        if let tempDict = results["Product"] as? Dictionary<String,AnyObject>{
                            self.product = Product.init(dictionary: tempDict, context: self.sharedContext)
                        }
                        if let image = results["Image"] as? String{
                                self.imageData = image
                        }
                        let pickSize = ["name":"Pick Size","user":"Nothing"]
                        let size = AttributeValue.init(dictionary: pickSize, context: self.sharedContext)
                        self.sizes.append(size)
                        if let tempSizes = results["Sizes"] as? Array<AnyObject>{
                            for i in tempSizes{
                                if let dict = i as? Dictionary<String,AnyObject>{
                                    let size = AttributeValue.init(dictionary: dict, context: self.sharedContext)
                                    self.sizes.append(size)
                                }
                            }
                        }
                        let pickStyle = ["name":"Pick Color","user":"Nothing"]
                        let style = Style.init(dictionary: pickStyle, context: self.sharedContext)
                        self.styles.append(style)
                        if let tempStyles = results["Styles"] as? Array<AnyObject>{
                            for i in tempStyles{
                                if let dict = i as? Dictionary<String,AnyObject>{
                                    let style = Style.init(dictionary: dict, context: self.sharedContext)
                                    self.styles.append(style)
                                }
                            }
                        }
                        if let tempPrices = results["Prices"] as? Array<AnyObject>{
                            if tempPrices.count > 0{
                                if let dict = tempPrices[0] as? Dictionary<String,AnyObject>{
                                    self.price = ProductPrice.init(dictionary: dict, context: self.sharedContext)
                                }
                            }
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.updateUI()
                        })
                    }
                }
            }
        })
    }

    // MARK: - PickerView Delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == sizeSpinner{
            return self.sizes.count
        }else{
            return self.styles.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if pickerView == sizeSpinner{
            let size = self.sizes[row]
            return size.name!
        }else{
            let style = self.styles[row]
            return style.name!
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == sizeSpinner{
            pickedSize = sizes[sizeSpinner.selectedRowInComponent(0)]
        }else if pickerView == colorSpinner{
            pickedColor = styles[colorSpinner.selectedRowInComponent(0)]
        }
        if pickedSize != nil && pickedColor != nil{
            if pickedSize!.user != "Nothing" && pickedColor!.user != "Nothing"{
                let params = ["safekey":pickedColor!.user!,"attributevalue":pickedSize!.user!]
                self.firstLabel.text = "Loading..."
                ServerDB.sharedInstance().httpGet(Constants.CountMethod, parameters: params, completionHandlerForGET: {[unowned self](data,error) in
                    if let results = data as? [String:AnyObject] {
                        if let result = results["Result"] as? String{
                            if result == "Success"{
                                if let dict = results["ItemCount"] as? Dictionary<String,AnyObject> {
                                    self.itemcount = ItemCount.init(dictionary: dict, context: self.sharedContext)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        if self.itemcount != nil{
                                            let count = self.itemcount!.total!.integerValue
                                            if count > 0{
                                                self.buyable = true
                                                self.addToCartButton.backgroundColor = UIColor.blueColor()
                                                self.addToCartButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                                                self.addToCartButton.setTitle("Add to Cart", forState: .Normal)
                                                self.addToCartButton.enabled = true
                                                self.firstLabel.text = "Updated"
                                            }else{
                                                self.buyable = false
                                                self.addToCartButton.backgroundColor = UIColor.whiteColor()
                                                self.addToCartButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
                                                self.addToCartButton.setTitle("Added to Cart", forState: .Normal)
                                                self.firstLabel.text = "Updated"
                                            }
                                        }
                                    })
                                }
                            }else{
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.buyable = false
                                    self.addToCartButton.backgroundColor = UIColor.whiteColor()
                                    self.addToCartButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
                                    self.addToCartButton.setTitle("Style Not Available", forState: .Normal)
                                    self.addToCartButton.enabled = false
                                    self.firstLabel.text = "Updated"
                                })
                            }
                        }
                    }
                    })
            }
        }
        
        
        
/*
        let size = sizes[colorSpinner.selectedRowInComponent(0)]
        let style = styles[sizeSpinner.selectedRowInComponent(0)]
        if style.user != nil && size.user != nil{
             if style.user != "Nothing" && size.user != "Nothing"{
                    //You can check for items in inventory
         
            }
        }
 */
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

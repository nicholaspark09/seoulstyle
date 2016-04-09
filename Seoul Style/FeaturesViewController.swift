//
//  FeaturesViewController.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/28/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit

class FeaturesViewController: UIViewController {

    var feature:Feature?{
        didSet{
            print("You got a feature")
        }
    }
    
    var image:String = ""
    
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = feature?.name!
        if self.image != ""{
            if let decodedData = NSData(base64EncodedString: image, options: .IgnoreUnknownCharacters){
                if let decodedimage = UIImage(data: decodedData){
                    self.imageView.translatesAutoresizingMaskIntoConstraints = true
                    self.imageView.image = decodedimage as UIImage
                }
            }
        }
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

}

//
//  PageCollectionViewCell.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/28/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    
    var page:Page?{
        didSet{
            self.label?.text = page!.name
            print("Setting the pagecell")
        }
    }
    var image = ""{
        didSet{
            if image != ""{
                print("Found an image with url: \(image)")
            if let decodedData = NSData(base64EncodedString: image, options: .IgnoreUnknownCharacters){
                if let decodedimage = UIImage(data: decodedData){

                    self.imageView?.image = decodedimage as UIImage
                    self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
                }
            }
            }
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var label: UILabel!
    
    func getDimensions(image:UIImage) -> (CGFloat,CGFloat){
        let x = image.size.width
        let y = image.size.height
        let temp = (120*y)/x
        return (120,temp)
    }
    
}

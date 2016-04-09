//
//  FeatureTableViewCell.swift
//  Seoul Style
//
//  Created by Nicholas Park on 4/2/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit

class FeatureTableViewCell: UITableViewCell {

    var feature:Feature?{
        didSet{
            self.nameLabel?.text = feature!.name!
            if feature != nil && feature!.info != nil{
                self.infoLabel?.text = feature!.info!
            }
        }
    }
    var featureImage: UIImage?{
        didSet{
            self.featureImageView?.translatesAutoresizingMaskIntoConstraints = true
            self.featureImageView?.image = featureImage
            self.featureImageView?.contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
    
    @IBOutlet var featureImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

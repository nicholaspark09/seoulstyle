//
//  PageProductTableViewCell.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/30/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit

class PageProductTableViewCell: UITableViewCell {

    var pageProduct:PageProduct?{
        didSet{
            self.productLabel?.text = pageProduct!.name!
        }
    }
    
    
    
    @IBOutlet var productImageView: UIImageView!
    
    @IBOutlet var productLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

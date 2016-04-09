//
//  Product.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/29/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import Foundation
import CoreData


class Product: NSManagedObject {

    struct Keys{
        static let Name = "name"
        static let Info = "info"
        static let Country = "country"
        static let Image = "image"
        static let Year = "year"
        static let User = "user"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary:[String:AnyObject],context:NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("Product", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        name = dictionary[Keys.Name] as? String
        user = dictionary[Keys.User] as? String
        info = dictionary[Keys.Info] as? String
        country = dictionary[Keys.Country] as? String
        year = dictionary[Keys.Year] as? NSNumber
    }

}

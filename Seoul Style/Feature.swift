//
//  Feature.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/28/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import Foundation
import CoreData


class Feature: NSManagedObject {
    
    struct Keys{
        static let Name = "name"
        static let Info = "info"
        static let Image = "image"
        static let DisplayOrder = "displayorder"
        static let Body = "body"
        static let User = "user"
        static let Country = "country"
    }

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary:[String:AnyObject],context:NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("Feature", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        name = dictionary[Keys.Name] as? String
        user = dictionary[Keys.User] as? String
        info = dictionary[Keys.Info] as? String
        body = dictionary[Keys.Body] as? String
        country = dictionary[Keys.Country] as? String
        displayorder = dictionary[Keys.DisplayOrder] as? NSNumber
        image = dictionary[Keys.Image] as? String
    }
}

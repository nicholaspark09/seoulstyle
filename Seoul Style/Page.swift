//
//  Page.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/28/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import Foundation
import CoreData


class Page: NSManagedObject {

    struct Keys{
        static let Name = "name"
        static let Info = "info"
        static let Image = "image"
        static let Displayorder = "displayorder"
        static let Country = "country"
        static let User = "user"
    }

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary:[String:AnyObject],context:NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("Page", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        name = dictionary[Keys.Name] as? String
        user = dictionary[Keys.User] as? String
        info = dictionary[Keys.Info] as? String
        country = dictionary[Keys.Country] as? String
        displayorder = dictionary[Keys.Displayorder] as? NSNumber
        image = dictionary[Keys.Image] as? String
    }
}

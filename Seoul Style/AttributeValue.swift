//
//  AttributeValue.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/31/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import Foundation
import CoreData


class AttributeValue: NSManagedObject {

    struct Keys{
        static let Name = "name"
        static let Info = "info"
        static let Details = "details"
        static let User = "user"
        static let Locale = "locale"
        static let Country = "country"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary:[String:AnyObject],context:NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("AttributeValue", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        name = dictionary[Keys.Name] as? String
        user = dictionary[Keys.User] as? String
        info = dictionary[Keys.Info] as? String
        country = dictionary[Keys.Country] as? String
        locale = dictionary[Keys.Locale] as? String
        details = dictionary[Keys.Details] as? String
    }

}

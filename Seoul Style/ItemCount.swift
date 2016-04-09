//
//  ItemCount.swift
//  Seoul Style
//
//  Created by Nicholas Park on 4/1/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import Foundation
import CoreData


class ItemCount: NSManagedObject {

    struct Keys{
        static let Name = "name"
        static let User = "user"
        static let Style = "style"
        static let AttributeValue = "attributevalue"
        static let Total = "total"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary:[String:AnyObject],context:NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("ItemCount", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        name = dictionary[Keys.Name] as? String
        user = dictionary[Keys.User] as? String
        style = dictionary[Keys.Style] as? String
        attributevalue = dictionary[Keys.AttributeValue] as? String
        total = dictionary[Keys.Total] as? NSNumber
    }

}

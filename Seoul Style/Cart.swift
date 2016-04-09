//
//  Cart.swift
//  Seoul Style
//
//  Created by Nicholas Park on 4/8/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import Foundation
import CoreData


class Cart: NSManagedObject {

    struct Keys{
        static let Name = "name"
        static let Info = "info"
        static let User = "user"
        static let Session = "session"
        static let Paid = "paid"
        static let Delivered = "delivered"
        static let Items = "items"
        static let Subtotal = "subtotal"
        static let Taxes = "taxes"
        static let Total = "total"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary:[String:AnyObject],context:NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("Cart", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        name = dictionary[Keys.Name] as? String
        user = dictionary[Keys.User] as? String
        info = dictionary[Keys.Info] as? String
        session = dictionary[Keys.Session] as? String
        paid = dictionary[Keys.Paid] as? Bool
        delivered = dictionary[Keys.Delivered] as? NSNumber
        items = dictionary[Keys.Items] as? NSNumber
        subtotal = dictionary[Keys.Subtotal] as? NSNumber
        taxes = dictionary[Keys.Taxes] as? NSNumber
        total = dictionary[Keys.Total] as? NSNumber
    }

}

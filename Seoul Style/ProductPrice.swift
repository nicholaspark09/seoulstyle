//
//  ProductPrice.swift
//  Seoul Style
//
//  Created by Nicholas Park on 4/1/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import Foundation
import CoreData


class ProductPrice: NSManagedObject {

    struct Keys{
        static let Name = "name"
        static let Price = "price"
        static let Country = "country"
        static let Currency = "currency"
        static let Usd = "usd"
        static let Product = "product"
        static let User = "user"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary:[String:AnyObject],context:NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("ProductPrice", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        name = dictionary[Keys.Name] as? String
        user = dictionary[Keys.User] as? String
        country = dictionary[Keys.Country] as? String
        currency = dictionary[Keys.Currency] as? String
        price = dictionary[Keys.Price] as? NSNumber
        usd = dictionary[Keys.Usd] as? NSNumber
        product = dictionary[Keys.Product] as? String
    }

}

//
//  PageProduct.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/29/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import Foundation
import CoreData


class PageProduct: NSManagedObject {

    struct Keys{
        static let Name = "name"
        static let Info = "info"
        static let Country = "country"
        static let User = "user"
        static let Product = "product"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary:[String:AnyObject],context:NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("PageProduct", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        name = dictionary[Keys.Name] as? String
        user = dictionary[Keys.User] as? String
        info = dictionary[Keys.Info] as? String
        product = dictionary[Keys.Product] as? String
    }

}

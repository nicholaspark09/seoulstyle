//
//  Day.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/28/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import Foundation
import CoreData


class Day: NSManagedObject {

    struct Keys{
        static let Name = "name"
        static let User = "user"
        static let Info = "info"
        static let Body = "body"
        static let Country = "country"
        static let CurrentDay = "currentday"
        static let Gender = "gender"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary:[String:AnyObject],context:NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("Day", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        name = dictionary[Keys.Name] as? String
        user = dictionary[Keys.User] as? String
        info = dictionary[Keys.Info] as? String
        body = dictionary[Keys.Body] as? String
        country = dictionary[Keys.Country] as? String
        currentday = dictionary[Keys.CurrentDay] as? String
        gender = dictionary[Keys.Gender] as? NSNumber
    }

}

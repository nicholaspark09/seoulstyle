//
//  ItemCount+CoreDataProperties.swift
//  Seoul Style
//
//  Created by Nicholas Park on 4/1/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ItemCount {

    @NSManaged var name: String?
    @NSManaged var user: String?
    @NSManaged var style: String?
    @NSManaged var attributevalue: String?
    @NSManaged var total: NSNumber?

}

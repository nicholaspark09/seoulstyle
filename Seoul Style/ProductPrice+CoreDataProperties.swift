//
//  ProductPrice+CoreDataProperties.swift
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

extension ProductPrice {

    @NSManaged var name: String?
    @NSManaged var price: NSNumber?
    @NSManaged var country: String?
    @NSManaged var currency: String?
    @NSManaged var usd: NSNumber?
    @NSManaged var product: String?
    @NSManaged var user: String?

}

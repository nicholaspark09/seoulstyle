//
//  Cart+CoreDataProperties.swift
//  Seoul Style
//
//  Created by Nicholas Park on 4/8/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Cart {

    @NSManaged var name: String?
    @NSManaged var info: String?
    @NSManaged var user: String?
    @NSManaged var session: String?
    @NSManaged var paid: NSNumber?
    @NSManaged var delivered: NSNumber?
    @NSManaged var items: NSNumber?
    @NSManaged var subtotal: NSNumber?
    @NSManaged var taxes: NSNumber?
    @NSManaged var total: NSNumber?

}

//
//  AttributeValue+CoreDataProperties.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/31/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AttributeValue {

    @NSManaged var name: String?
    @NSManaged var info: String?
    @NSManaged var details: String?
    @NSManaged var attributegroup: String?
    @NSManaged var locale: String?
    @NSManaged var country: String?
    @NSManaged var user: String?

}

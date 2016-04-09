//
//  Feature+CoreDataProperties.swift
//  Seoul Style
//
//  Created by Nicholas Park on 3/28/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Feature {

    @NSManaged var name: String?
    @NSManaged var info: String?
    @NSManaged var image: String?
    @NSManaged var displayorder: NSNumber?
    @NSManaged var body: String?
    @NSManaged var user: String?
    @NSManaged var country: String?

}

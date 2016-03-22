//
//  ContactList+CoreDataProperties.swift
//  MyContacts
//
//  Created by student on 3/22/16.
//  Copyright © 2016 Josh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ContactList {

    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var phone: String

}

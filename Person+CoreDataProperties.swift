//
//  Person+CoreDataProperties.swift
//  CoreDataToDOList
//
//  Created by Yugandhar Kommineni on 11/13/21.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int64

}

extension Person : Identifiable {

}

//
//  Product+CoreDataProperties.swift
//  
//
//  Created by Федор on 15.05.17.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var nameOfTea: String?
    @NSManaged public var teaUrl: String?
    @NSManaged public var teaType: String?

}

//
//  TeaData+CoreDataProperties.swift
//  
//
//  Created by Федор on 16.05.17.
//
//

import Foundation
import CoreData


extension TeaData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TeaData> {
        return NSFetchRequest<TeaData>(entityName: "TeaData")
    }

    @NSManaged public var nameOfTea: String
    @NSManaged public var typeOfTea: String
    @NSManaged public var urlOfTea: String

}

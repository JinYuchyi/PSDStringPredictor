//
//  SizeTracking+CoreDataProperties.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 8/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//
//

import Foundation
import CoreData


extension SizeTracking {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SizeTracking> {
        return NSFetchRequest<SizeTracking>(entityName: "SizeTracking")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var size: Int16
    @NSManaged public var tracking: Int16

}

//
//  PetKeyword+CoreDataProperties.swift
//  CoCo
//
//  Created by 강준영 on 15/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//
//

import Foundation
import CoreData

extension PetKeyword {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PetKeyword> {
        return NSFetchRequest<PetKeyword>(entityName: "PetKeyword")
    }

    @NSManaged public var date: String?
    @NSManaged public var keywords: NSObject
    @NSManaged public var pet: String

}

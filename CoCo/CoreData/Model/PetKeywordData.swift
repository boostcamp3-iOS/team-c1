//
//  PetKeyword.swift
//  CoCo
//
//  Created by 강준영 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

struct PetKeywordData: CoreDataEntity {
    // MARK: - Propertise
    var keywords: [String] = []
    var pet = ""
    var objectID: NSManagedObjectID?
}

//
//  PetKeyword.swift
//  CoCo
//
//  Created by 강준영 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

struct PetKeywordData {
    // MARK: - Propertise
    var keywords: [String] = []
    var pet = ""
    var objectID: NSManagedObjectID?
}

extension PetKeywordData: CoreDataEntity {
    // MARK: - Method
    func toCoreData(context: NSManagedObjectContext?) {
        guard let context = context else { return }
        let petKeyword = PetKeyword(context: context)
        petKeyword.keywords = self.keywords as NSObject
        petKeyword.pet = self.pet
    }
}

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
    var keywords: [String] = []
    var pet = ""
    var objectID: NSManagedObjectID?
}

extension PetKeywordData: CoreDataEntity {
    func toCoreData(context: NSManagedObjectContext?) -> NSManagedObject? {
        guard let context = context else { return nil }
        let petKeyword = PetKeyword(context: context)
        petKeyword.keywords = self.keywords as NSObject
        petKeyword.pet = self.pet
        return petKeyword
    }

}

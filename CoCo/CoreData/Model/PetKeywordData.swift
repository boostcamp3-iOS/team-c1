//
//  PetKeyword.swift
//  CoCo
//
//  Created by 강준영 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

struct PetKeywordData: CoreDataStructEntity {
    // MARK: - Propertise
    var objectID: NSManagedObjectID?
    var keywords: [String] = []
    var pet = ""

    // MARK: - Initializer
    init() { }

    init(pet: String, keywords: [String]) {
        self.pet = pet
        self.keywords = keywords
    }
}

extension PetKeywordData: Mapping {
    mutating func mappinng(from: NSManagedObject) {
        self.keywords = from.value(forKeyPath: "keywords")
        self.pet = from.value(forKeyPath: "pet")
        self.objectID = from.objectID
    }

    func mappinng(to: NSManagedObject) {
        to.setValue(self.keywords, forKey: "keywords")
        to.setValue(self.pet, forKey: "pet")
    }
}

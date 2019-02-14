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
    var keywords: Keyword?
    var pet: Pet?

    // MARK: - Initializer
    init() { }

    init(pet: Pet, keywords: Keyword) {
        self.pet = pet
        self.keywords = keywords
    }
}

extension PetKeywordData: Mapping {
    mutating func mappinng(from: NSManagedObject) {
        if  let pet = from.petValue(forKeyPath: "pet") {
            self.pet = pet
        }
        if let keywords = from.keywordValue(forKeyPath: "keywords") {
            self.keywords = keywords
        }
        self.objectID = from.objectID
    }

    func mappinng(to: NSManagedObject) {
        to.setValue(self.keywords, forKey: "keywords")
        to.setValue(self.pet, forKey: "pet")
    }
}

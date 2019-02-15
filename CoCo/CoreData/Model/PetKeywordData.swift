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
    var keywords: [String]?
    var pet: String?
    var date: String?

    // MARK: - Initializer
    init() {
        self.date = createDate()
    }

    init(pet: String, keywords: [String]) {
        self.init()
        self.pet = pet
        self.keywords = keywords
    }

    // MARK: Method
    func createDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}

extension PetKeywordData: Mapping {
    mutating func mappinng(from: NSManagedObject) {
        self.pet = from.value(forKeyPath: "pet")
        self.keywords = from.value(forKeyPath: "keywords")
        self.objectID = from.objectID
        self.date = from.value(forKeyPath: "date")
    }

    func mappinng(to: NSManagedObject) {
        to.setValue(self.date, forKey: "date")
        to.setValue(self.keywords, forKey: "keywords")
        to.setValue(self.pet, forKey: "pet")
    }
}

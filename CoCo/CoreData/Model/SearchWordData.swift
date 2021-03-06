//
//  SearchKeywordData.swift
//  CoCo
//
//  Created by 강준영 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

struct SearchWordData: CoreDataStructEntity {
    // MARK: Properties
    var date: String?
    var searchWord = ""
    var pet: String?
    var objectID: NSManagedObjectID?

    // MARK: Initializer
    init() {
        self.date = createDate()
    }

    init(pet: String, searchWord: String) {
        self.pet = pet
        self.date = createDate()
        self.searchWord = searchWord
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

extension SearchWordData: Mapping {
    mutating func mappinng(from: NSManagedObject) {
        self.pet = from.value(forKeyPath: "pet")
        self.date = from.value(forKeyPath: "date")
        self.searchWord = from.value(forKeyPath: "searchWord")
        self.objectID = from.objectID
    }

    func mappinng(to: NSManagedObject) {
        to.setValue(self.date, forKey: "date")
        to.setValue(self.pet, forKey: "pet")
        to.setValue(self.searchWord, forKey: "searchWord")
    }

}

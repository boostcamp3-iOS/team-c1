//
//  SearchKeywordData.swift
//  CoCo
//
//  Created by 강준영 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

struct SearchKeywordData {
    var date = Date()
    var searchWord = ""
    var objectID: NSManagedObjectID?
}

extension SearchKeywordData: CoreDataEntity {
    func toCoreData(context: NSManagedObjectContext?) -> NSManagedObject? {
        guard let context = context else { return nil }
        let searchKeyword = SearchKeyword(context: context)
        searchKeyword.date = self.date as NSDate
        searchKeyword.searchWord = self.searchWord
        return searchKeyword
    }

}

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
    // MARK: Properties
    var date = Date()
    var searchWord = ""
    var objectID: NSManagedObjectID?
}

extension SearchKeywordData: CoreDataEntity {
    // MARK: - Method
    func toCoreData(context: NSManagedObjectContext?) {
        guard let context = context else { return }
        let searchKeyword = SearchKeyword(context: context)
        searchKeyword.date = self.date as NSDate
        searchKeyword.searchWord = self.searchWord
    }

}

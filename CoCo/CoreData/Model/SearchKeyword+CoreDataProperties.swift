//
//  SearchKeyword+CoreDataProperties.swift
//  CoCo
//
//  Created by 강준영 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//
//

import Foundation
import CoreData

extension SearchKeyword {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchKeyword> {
        return NSFetchRequest<SearchKeyword>(entityName: "SearchKeyword")
    }

    @NSManaged public var date: NSDate
    @NSManaged public var searchWord: String

}

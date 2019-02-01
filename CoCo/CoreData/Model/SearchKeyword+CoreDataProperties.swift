//
//  SearchKeyword+CoreDataProperties.swift
//  CoCo
//
//  Created by 강준영 on 01/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//
//

import Foundation
import CoreData


extension SearchKeyword {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchKeyword> {
        return NSFetchRequest<SearchKeyword>(entityName: "SearchKeyword")
    }

    @NSManaged public var date: String?
    @NSManaged public var searchWord: String

}

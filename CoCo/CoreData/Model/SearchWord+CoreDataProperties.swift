//
//  SearchWord+CoreDataProperties.swift
//  CoCo
//
//  Created by 강준영 on 04/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//
//

import Foundation
import CoreData

extension SearchWord {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchWord> {
        return NSFetchRequest<SearchWord>(entityName: "SearchWord")
    }

    @NSManaged public var date: String?
    @NSManaged public var searchWord: String
    @NSManaged public var pet: String
}

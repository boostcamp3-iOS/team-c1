//
//  SearchWord+CoreDataProperties.swift
//  CoCo
//
//  Created by 강준영 on 14/02/2019.
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
    @NSManaged public var pet: NSObject
    @NSManaged public var searchWord: String

}

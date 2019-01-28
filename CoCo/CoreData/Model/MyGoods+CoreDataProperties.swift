//
//  MyGoods+CoreDataProperties.swift
//  CoCo
//
//  Created by 강준영 on 28/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//
//

import Foundation
import CoreData

extension MyGoods {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyGoods> {
        return NSFetchRequest<MyGoods>(entityName: "MyGoods")
    }

    @NSManaged public var date: NSDate
    @NSManaged public var image: String
    @NSManaged public var isFavorite: Bool
    @NSManaged public var link: String
    @NSManaged public var price: String
    @NSManaged public var productId: String
    @NSManaged public var title: String
    @NSManaged public var isTwoAttribute: Bool

}

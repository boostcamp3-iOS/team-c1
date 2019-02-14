//
//  MyGoods+CoreDataProperties.swift
//  CoCo
//
//  Created by 강준영 on 14/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//
//

import Foundation
import CoreData

extension MyGoods {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyGoods> {
        return NSFetchRequest<MyGoods>(entityName: "MyGoods")
    }

    @NSManaged public var date: String?
    @NSManaged public var image: String
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isLatest: Bool
    @NSManaged public var link: String
    @NSManaged public var pet: NSObject
    @NSManaged public var price: String
    @NSManaged public var productID: String
    @NSManaged public var searchWord: String
    @NSManaged public var shoppingmall: String
    @NSManaged public var title: String

}

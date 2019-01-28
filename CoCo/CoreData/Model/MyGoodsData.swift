//
//  MyGoodsData.swift
//  CoCo
//
//  Created by 강준영 on 27/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

struct MyGoodsData {
    let date: Date
    let title: String
    let link: String
    let image: String
    let isFavorite: Bool
    let price: String
    let productId: String

    init(date: Date, title: String, link: String, image: String, isFavorite: Bool, price: String, productId: String) {
        self.date = date
        self.title = title
        self.link = link
        self.image = image
        self.isFavorite = isFavorite
        self.price = price
        self.productId = productId
    }
}

extension MyGoodsData: CoreDataEntity {
    func toCoreData(context: NSManagedObjectContext?) -> NSManagedObject? {
        guard let context = context else { return nil }
        let myGoods = MyGoods(context: context)
        if self is MyGoodsData {
            myGoods.date = self.date as NSDate
            myGoods.title = self.title
            myGoods.link = self.link
            myGoods.image = self.image
            myGoods.isFavorite = self.isFavorite
            myGoods.price = self.price
            myGoods.productId = self.productId
            return myGoods
        } else {
            return nil
        }
    }

}

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
    var date = Date() //시간 자동저장?
    var title: String = ""
    var link: String = ""
    var image: String = ""
    var isFavorite: Bool = false
    var isLatest: Bool = false
    var price: String = ""
    var productId: String = ""
    var objectId: NSManagedObjectID?
    var searchWord = ""
}

extension MyGoodsData: CoreDataEntity {
    func toCoreData(context: NSManagedObjectContext?) -> NSManagedObject? {
        guard let context = context else { return nil }
        let myGoods = MyGoods(context: context)

        myGoods.date = self.date as NSDate
        myGoods.title = self.title
        myGoods.link = self.link
        myGoods.image = self.image
        myGoods.isFavorite = self.isFavorite
        myGoods.price = self.price
        myGoods.productId = self.productId
        myGoods.searchWord = self.searchWord
        return myGoods

    }

}

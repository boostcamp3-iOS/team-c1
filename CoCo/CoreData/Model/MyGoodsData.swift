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
    // MARK: - Propertise
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

extension MyGoodsData: Comparable {
    static func < (lhs: MyGoodsData, rhs: MyGoodsData) -> Bool {
        return lhs.searchWord < rhs.searchWord
    }
}

extension MyGoodsData: CoreDataEntity {
    // MARK: - Method
    func toCoreData(context: NSManagedObjectContext?) {
        guard let context = context else { return }
        let myGoods = MyGoods(context: context)
        myGoods.date = self.date as NSDate
        myGoods.title = self.title
        myGoods.link = self.link
        myGoods.image = self.image
        myGoods.isFavorite = self.isFavorite
        myGoods.price = self.price
        myGoods.productId = self.productId
        myGoods.searchWord = self.searchWord

    }

}

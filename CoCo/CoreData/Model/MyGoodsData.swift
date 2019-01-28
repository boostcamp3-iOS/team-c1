//
//  MyGoodsData.swift
//  CoCo
//
//  Created by 강준영 on 27/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

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

}

//
//  Model.swift
//  CoCo
//
//  Created by 이호찬 on 25/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

struct APIResponseShoppingData: Codable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int

    let items: [ShoppingItem]
}

struct ShoppingItem: Codable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let hprice: String
    let mallName: String
    let productId: String
    let productType: String
}

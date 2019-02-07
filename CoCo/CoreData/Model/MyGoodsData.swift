//
//  MyGoodsData.swift
//  CoCo
//
//  Created by 강준영 on 27/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

struct MyGoodsData: CoreDataStructEntity {
  
    // MARK: - Propertise
    var date: String?
    var title: String = ""
    var link: String = ""
    var image: String = ""
    var isFavorite: Bool = false
    var isLatest: Bool = false
    var price: String = ""
    var productId: String = ""
    var objectID: NSManagedObjectID?
    var searchWord: String?
    var pet = ""
    var shoppingmall: String = ""
    
    //MARK: Initializer
    init() {
        self.date = createDate()
    }
    
    init(pet: String, title: String, link: String, image: String, isFavorite: Bool, isLatest: Bool, price: String, productId: String, searchWord: String, shoppingmall: String) {
        self.pet = pet
        self.title = title
        self.link = link
        self.image = image
        self.isFavorite = isFavorite
        self.isLatest = isLatest
        self.price = price
        self.productId = productId
        self.searchWord = searchWord
        self.shoppingmall = shoppingmall
    }
    
    // MARK: - Method
    func createDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}

extension MyGoodsData: Comparable {
    static func < (lhs: MyGoodsData, rhs: MyGoodsData) -> Bool {
        return lhs.productId < rhs.productId
    }
}

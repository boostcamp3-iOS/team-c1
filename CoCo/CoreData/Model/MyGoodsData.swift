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
    var productID: String = ""
    var objectID: NSManagedObjectID?
    var searchWord: String?
    var pet = ""
    var shoppingmall: String = ""

    // MARK: Initializer
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
        self.productID = productId
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
        return lhs.productID < rhs.productID
    }
}

extension MyGoodsData: Mapping {
    mutating func mappinng(from: NSManagedObject) {
        self.date = from.value(forKeyPath: "date")
        self.image = from.value(forKeyPath: "image")
        self.isFavorite = from.value(forKeyPath: "isFavorite")
        self.isLatest = from.value(forKeyPath: "isLatest")
        self.link = from.value(forKeyPath: "link")
        self.objectID = from.objectID
        self.pet = from.value(forKeyPath: "pet")
        self.price = from.value(forKeyPath: "price")
        self.productID = from.value(forKeyPath: "productID")
        self.searchWord = from.value(forKeyPath: "searchWord")
        self.shoppingmall = from.value(forKeyPath: "shoppingmall")
        self.title = from.value(forKeyPath: "title")
    }

    func mappinng(to: NSManagedObject) {
        to.setValue(self.date, forKey: "date")
        to.setValue(self.image, forKey: "image")
        to.setValue(self.isFavorite, forKey: "isFavorite")
        to.setValue(self.isLatest, forKey: "isLatest")
        to.setValue(self.link, forKey: "link")
        to.setValue(self.pet, forKey: "pet")
        to.setValue(self.price, forKey: "price")
        to.setValue(self.productID, forKey: "productID")
        to.setValue(self.searchWord, forKey: "searchWord")
        to.setValue(self.shoppingmall, forKey: "shoppingmall")
        to.setValue(self.title, forKey: "title")
    }

}

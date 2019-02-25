//
//  MockMyGoodsCoreDataManager.swift
//  CoreDataTests
//
//  Created by 강준영 on 25/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
@testable import CoCo

class MockMyGoodsCoreDataManager: MyGoodsCoreDataManagerType {
    func fetchFavoriteGoods(pet: String?) throws -> [MyGoodsData]? {
        if let pet = pet {
            return [MyGoodsData(pet: pet, title: "강아지옷", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "12345", searchWord: "뷰티", shoppingmall: "네이버")]
        } else {
            return [MyGoodsData(pet: "강아지", title: "강아지옷", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "999999", searchWord: "뷰티", shoppingmall: "네이버"), MyGoodsData(pet: "고양이", title: "고양이옷", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "55555", searchWord: "뷰티", shoppingmall: "네이버")]
        }
    }

    func fetchLatestGoods(pet: String?, isLatest: Bool, ascending: Bool) throws -> [MyGoodsData]? {
        if let pet = pet {
            return [MyGoodsData(pet: pet, title: "강아지샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "54321", searchWord: "뷰티", shoppingmall: "네이버"), MyGoodsData(pet: pet, title: "강아지샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "54321", searchWord: "뷰티", shoppingmall: "네이버")]
        } else {
            return [MyGoodsData(pet: "고양이", title: "고양이샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "9875", searchWord: "뷰티", shoppingmall: "네이버"), MyGoodsData(pet: "강아지", title: "강아지샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "58765", searchWord: "뷰티", shoppingmall: "네이버")]
        }
    }

    func fetchProductID(productID: String) -> MyGoods? {
        let productIDs = ["654321", "123456"]
        if productIDs.contains(productID) {
            return MyGoods()
        } else {
            return nil
        }
    }

    func deleteFavoriteAllObjects(pet: String) throws -> Bool {
        if pet == "고양이" || pet == "강아지" {
            return true
        } else {
            return false
        }
    }

    func deleteLatestAllObjects(pet: String, isLatest: Bool) throws -> Bool {
        if pet == "고양이" || pet == "강아지" {
            return true
        } else {
            return false
        }
    }

    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is MyGoodsData {
            return true
        } else {
            return false
        }
    }

    func fetchObjects(pet: String?) throws -> [CoreDataStructEntity]? {
        if let pet = pet {
            if pet == "고양이" || pet == "강아지" {
                return [MyGoodsData(pet: pet, title: "강아지간식", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "66666", searchWord: "푸드", shoppingmall: "네이버")]
            }
            return nil
        } else {
            return nil
        }
    }

    func updateObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is MyGoodsData {
            return true
        } else {
            return false
        }
    }

    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is MyGoodsData {
            return true
        } else {
            return false
        }
    }

}

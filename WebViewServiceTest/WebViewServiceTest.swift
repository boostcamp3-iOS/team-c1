//
//  WebViewServiceTest.swift
//  WebViewServiceTest
//
//  Created by 최영준 on 23/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import XCTest
@testable import CoCo

class WebViewServiceTest: XCTestCase {
    var service: WebViewService!

    override func setUp() {
        let data = MyGoodsData(pet: "강아지", title: "강아지옷", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "12345", searchWord: "뷰티", shoppingmall: "네이버")
        service = WebViewService(data: data)
        let manager = MockMyGoodsCoreDataManager()
        service.setMyGoodsCoreDataManager(manager)
    }

    override func tearDown() {
        service = nil
    }

    /*
     @discardableResult func insert() -> Bool
     func fetchData()
     func updateFavorite(_ isFavorite: Bool)
     */

    func testUpdateFavorite() {
        service.updateFavorite(true)
        XCTAssert(service.myGoodsData.isFavorite, "testUpdateFavorite 실패")
        service.updateFavorite(false)
        XCTAssert(!service.myGoodsData.isFavorite, "testUpdateFavorite 실패")
    }
}

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
            return [MyGoodsData(pet: pet, title: "강아지샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "54321", searchWord: "뷰티", shoppingmall: "네이버")]
        } else {
            return [MyGoodsData(pet: "고양이", title: "고양이샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "9875", searchWord: "뷰티", shoppingmall: "네이버"), MyGoodsData(pet: "강아지", title: "강아지샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "58765", searchWord: "뷰티", shoppingmall: "네이버")]
        }
    }

    func fetchProductID(productID: String) -> MyGoods? {
        let productIDs = ["12345", "54321"]
        let myGoods = MyGoods()
        myGoods.date = "2018-01-01"
        myGoods.image = "www.naver.com"
        myGoods.isFavorite = true
        myGoods.isLatest = true
        myGoods.link = "www.naver.com"
        myGoods.pet = "고양이"
        myGoods.price = "15,000"
        myGoods.productID = productID
        myGoods.searchWord = "장난감"
        myGoods.shoppingmall = "네이버 쇼핑"
        myGoods.title = "고양이 장난감"
        if productIDs.contains(productID) {
            print("리턴~~")
            return myGoods
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
            if isLatest == true {
                return true
            }
            return false
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

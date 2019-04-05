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
        let manager = MockMyGoodsCoreDataManager()
        service = WebViewService(data: data, manager: manager)
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

    func testFetchData() {
        service.fetchData { (_, error) in
            if let error = error {
                XCTAssertNil(error, "Fetch Error!! \(error)")
            }
        }
    }
}

class MockMyGoodsCoreDataManager: MyGoodsCoreDataManagerType {
    func fetchObjects(pet: String?, completion: @escaping ([CoreDataStructEntity]?, Error?) -> Void) {
        if let pet = pet {
            if pet == "고양이" || pet == "강아지" {
                completion([MyGoodsData(pet: pet, title: "강아지간식", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "66666", searchWord: "푸드", shoppingmall: "네이버")], nil)
            }
        } else {
            completion(nil, nil)
        }
    }

    func fetchFavoriteGoods(pet: String?, completion: @escaping ([MyGoodsData]?, Error?) -> Void) {
        if let pet = pet {
            completion([MyGoodsData(pet: pet, title: "강아지옷", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "12345", searchWord: "뷰티", shoppingmall: "네이버")], nil)
        } else {
            completion([MyGoodsData(pet: "강아지", title: "강아지옷", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "999999", searchWord: "뷰티", shoppingmall: "네이버"), MyGoodsData(pet: "고양이", title: "고양이옷", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "55555", searchWord: "뷰티", shoppingmall: "네이버")], nil)
        }
    }

    func fetchLatestGoods(pet: String?, isLatest: Bool, ascending: Bool, completion: @escaping ([MyGoodsData]?, Error?) -> Void) {
        if let pet = pet {
            completion([MyGoodsData(pet: pet, title: "강아지샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "54321", searchWord: "뷰티", shoppingmall: "네이버"), MyGoodsData(pet: pet, title: "강아지샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "54321", searchWord: "뷰티", shoppingmall: "네이버")], nil)
        } else {
            completion([MyGoodsData(pet: "고양이", title: "고양이샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "9875", searchWord: "뷰티", shoppingmall: "네이버"), MyGoodsData(pet: "강아지", title: "강아지샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "58765", searchWord: "뷰티", shoppingmall: "네이버")], nil)
        }
    }

    func fetchProductID(productID: String, completion: @escaping (MyGoods?, Error?) -> Void) {
        let productIDs = ["654321", "123456"]
        if productIDs.contains(productID) {
            completion(MyGoods(), nil)
        } else {
            completion(nil, nil)
        }
    }

    func deleteFavoriteAllObjects(pet: String, completion: @escaping (Bool, Error?) -> Void) {
        if pet == "고양이" || pet == "강아지" {
            completion(true, nil)
        } else {
            completion(false, nil)
        }
    }

    func deleteLatestAllObjects(pet: String, isLatest: Bool, completion: @escaping (Bool, Error?) -> Void) {
        if pet == "고양이" || pet == "강아지" {
            completion(true, nil)
        } else {
            completion(false, nil)
        }
    }

    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T, completion: @escaping (Bool, Error?) -> Void) {
        if coreDataStructType is MyGoodsData {
            completion(true, nil)
        } else {
            completion(false, nil)
        }
    }

    func updateObject<T>(_ coreDataStructType: T, completion:@escaping
        (Bool) -> Void) {
        if coreDataStructType is MyGoodsData {
            completion(true)
        } else {
            completion(false)
        }
    }

    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T, completion: @escaping (Bool) -> Void) {
        if coreDataStructType is MyGoodsData {
            completion(true)
        } else {
            completion(false)
        }
    }

}

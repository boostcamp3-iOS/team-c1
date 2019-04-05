//
//  MyGoodsServiceTest.swift
//  MyGoodsServiceTest
//
//  Created by 최영준 on 21/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import XCTest
@testable import CoCo

class MyGoodsServiceTest: XCTestCase {

    var service: MyGoodsService!

    override func setUp() {
        let manager = MockMyGoodsCoreDataManager()
        service = MyGoodsService(manager: manager)
    }

    override func tearDown() {
        service = nil
    }

    /*
     func fetchGoods()
     - private func fetchFavoriteGoods() -> [MyGoodsData]
     - private func fetchRecentGoods() -> [MyGoodsData]
     func deleteGoods(index: Int, completion: @escaping () -> Void)
     - private func deleteRecentGoods(_ data: MyGoodsData) -> Bool
     - private func deleteFavoriteGoods(_ data: MyGoodsData) -> Bool
     - private func deleteObject(_ data: MyGoodsData) -> Bool
     */

    func testFetchFavoriteGoods() {
        service.fetchGoods { [weak self] (error) in
            guard let self = self else {
                return
            }
            if let error = error {
                XCTAssertNil(error, "Fetch Error!! \(error)")
            }
            XCTAssert(!self.service.dataIsEmpty, "testFetchFavoriteGoods 실패")
        }
    }

    func testDeleteGoods() {
        service.fetchGoods { [weak self] (error) in
            guard let self = self else {
                return
            }
            if let error = error {
                XCTAssertNil(error, "Fetch Error!! \(error)")
            }
            print(self.service.recentGoods, self.service.favoriteGoods)
            for _ in 0 ..< self.service.recentGoods.count {
                self.service.deleteGoods(index: 0)
            }
            XCTAssert(self.service.recentGoods.isEmpty, "testDeleteGoods 실패: recent")
            for _ in 0 ..< self.service.favoriteGoods.count {
                self.service.deleteGoods(index: 10)
            }
            XCTAssert(self.service.favoriteGoods.isEmpty, "testDeleteGoods 실패: favoriteGoods")
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
        var result = [MyGoodsData]()
        if let pet = pet {
            for i in 0 ..< 15 {
                let data = MyGoodsData(pet: pet, title: "강아지샴푸\(i)", link: "www.naver.com", image: "www.naver.com", isFavorite: false, isLatest: true, price: "12000", productID: "\(i)9875", searchWord: "뷰티", shoppingmall: "네이버")
                result.append(data)
            }
            completion(result, nil)
        } else {
            for i in 0 ..< 15 {
                let data = MyGoodsData(pet: "고양이", title: "고양이샴푸\(i)", link: "www.naver.com", image: "www.naver.com", isFavorite: false, isLatest: true, price: "12000", productID: "\(i)9875", searchWord: "뷰티", shoppingmall: "네이버")
                result.append(data)
            }
            completion(result, nil)
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

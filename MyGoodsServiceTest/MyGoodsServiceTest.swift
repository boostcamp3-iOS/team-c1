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

    let service = MyGoodsService()

    override func setUp() {
        let manager = MockMyGoodsCoreDataManager()
        service.setMyGoodsCoreDataManager(manager)
    }

    override func tearDown() {
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
        service.fetchGoods()
        XCTAssert(!service.dataIsEmpty, "testFetchFavoriteGoods 실패")
    }

    func testDeleteGoods() {
        service.fetchGoods()
        for _ in 0 ..< service.recentGoods.count {
            service.deleteGoods(index: 0)
        }
        XCTAssert(service.recentGoods.isEmpty, "testDeleteGoods 실패: recent")
        for _ in 0 ..< service.favoriteGoods.count {
            service.deleteGoods(index: 10)
        }
        XCTAssert(service.favoriteGoods.isEmpty, "testDeleteGoods 실패: favoriteGoods")
    }
}

class MockMyGoodsCoreDataManager: MyGoodsCoreDataManagerType {
    func fetchFavoriteGoods(pet: String?) throws -> [MyGoodsData]? {
        var result = [MyGoodsData]()
        for i in 0 ..< 10 {
            let goods = MyGoodsData(pet: "강아지", title: "찜한 상품 \(i)", link: "", image: "", isFavorite: true, isLatest: false, price: "", productID: "\(i)", searchWord: "찜 검색어 \(i)", shoppingmall: "")
            result.append(goods)
        }
        return result
    }

    func fetchLatestGoods(pet: String?, isLatest: Bool, ascending: Bool) throws -> [MyGoodsData]? {
        var result = [MyGoodsData]()
        for i in 10 ..< 20 {
            let goods = MyGoodsData(pet: "강아지", title: "최근본 상품 \(i) ", link: "http://search.shopping.naver.com/gate.nhn?id=17518707732", image: "https://shopping-phinf.pstatic.net/main_1751870/17518707732.jpg", isFavorite: false, isLatest: true, price: "9,230", productID: "17518707732", searchWord: "최근 검색어 \(i)", shoppingmall: "민들레상회")
            result.append(goods)
        }
        return result
    }

    func deleteFavoriteAllObjects(pet: String) throws -> Bool {
        return false
    }
    func deleteLatestAllObjects(pet: String, isLatest: Bool) throws -> Bool {
        return false
    }

    func insert<T>(_ coreDataStructType: T) throws -> Bool {
        return false
    }

    func fetchObjects(pet: String? = nil) throws -> [CoreDataStructEntity]? {
        return nil
    }

    func updateObject<T>(_ coreDataStructType: T) throws -> Bool {
        return false
    }

    func deleteObject<T>(_ coreDataStructType: T) throws -> Bool {
        return false
    }

    @discardableResult func deleteFavoriteAllObjects(pet: String, isFavorite: Bool) throws -> Bool {
        return false
    }
}

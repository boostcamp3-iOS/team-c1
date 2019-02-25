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
        service.fetchGoods()
        XCTAssert(!service.dataIsEmpty, "testFetchFavoriteGoods 실패")
    }
    
    func testDeleteGoods() {
        service.fetchGoods()
        print(service.recentGoods, service.favoriteGoods)
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
        if let pet = pet {
            for i in 0 ..< 10 {
                let data = MyGoodsData(pet: pet, title: "강아지옷\(i)", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "\(i)9875", searchWord: "뷰티", shoppingmall: "네이버")
                result.append(data)
            }
        } else {
            for i in 0 ..< 10 {
                let data = MyGoodsData(pet: "고양이", title: "고양이옷\(i)", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "\(i)9875", searchWord: "뷰티", shoppingmall: "네이버")
                result.append(data)
            }
        }
        return result
    }
    
    func fetchLatestGoods(pet: String?, isLatest: Bool, ascending: Bool) throws -> [MyGoodsData]? {
        var result = [MyGoodsData]()
        if let pet = pet {
            for i in 0 ..< 15 {
                let data = MyGoodsData(pet: pet, title: "강아지샴푸\(i)", link: "www.naver.com", image: "www.naver.com", isFavorite: false, isLatest: true, price: "12000", productID: "\(i)9875", searchWord: "뷰티", shoppingmall: "네이버")
                result.append(data)
            }
        } else {
            for i in 0 ..< 15 {
                let data = MyGoodsData(pet: "고양이", title: "고양이샴푸\(i)", link: "www.naver.com", image: "www.naver.com", isFavorite: false, isLatest: true, price: "12000", productID: "\(i)9875", searchWord: "뷰티", shoppingmall: "네이버")
                result.append(data)
            }
        }
        let data = MyGoodsData(pet: "고양이", title: "고양이샴푸16", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "169875", searchWord: "뷰티", shoppingmall: "네이버")
        result.append(data)
        return result
    }
    
    func fetchProductID(productID: String) -> MyGoods? {
        return nil
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

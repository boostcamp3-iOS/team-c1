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
        service.fetchData()
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

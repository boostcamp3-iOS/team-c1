//
//  CoreDataTests.swift
//  CoreDataTests
//
//  Created by 이호찬 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import XCTest
import CoreData
@testable import CoCo

class MockSearchWordCoreDataManager: SearchWordCoreDataManagerType {

    @discardableResult func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is SearchWordData {
            return true
        } else {
            return false
        }
    }

    func fetchOnlySearchWord(pet: String) throws -> [String]? {
        if pet == "고양이" || pet == "강아지" {
            return ["쿠션", "신발", "옷"]
        } else {
            return nil
        }
    }

    func fetchObjects(pet: String? = nil) throws -> [CoreDataStructEntity]? {
        if let pet = pet {
            return [SearchWordData(pet: pet, searchWord: "배변용품")]
        } else {
            return [SearchWordData(pet: "고양이", searchWord: "배변용품"), SearchWordData(pet: "강아지", searchWord: "강아지간식")]
        }
    }

    func updateObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is SearchWordData {
            return true
        } else {
            return false
        }
    }

    @discardableResult func updateObject(searchWord: String, pet: String) throws -> Bool {
        if pet == "고양이" || pet == "강아지" {
            return true
        } else {
            return false
        }
    }

    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is SearchWordData {
            return true
        } else {
            return false
        }
    }

    @discardableResult func deleteAllObjects(pet: String) throws ->  Bool {
        if pet == "고양이" || pet == "강아지" {
            return true
        } else {
            return false
        }
    }
}

class MockPetKeywordCoreDataManager: PetKeywordCoreDataManagerType {
    func fetchOnlyKeyword(pet: String) throws -> [String]? {
        return ["배변", "놀이", "뷰티", "스타일"]
    }

    func fetchOnlyPet() throws -> String? {
        return "고양이"
    }

    func deleteAllObjects(pet: String) throws -> Bool {
        if pet == "고양이" || pet == "강아지" {
            return true
        } else {
            return false
        }
    }

    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is PetKeywordData {
            return true
        } else {
            return false
        }
    }

    func fetchObjects(pet: String?) throws -> [CoreDataStructEntity]? {
        if let pet = pet {
            return [PetKeywordData(pet: pet, keywords: ["배변", "뷰티", "놀이"])]
        } else {
             return [PetKeywordData(pet: "강아지", keywords: ["배변", "뷰티", "놀이"]), PetKeywordData(pet: "고양이", keywords: ["배변", "뷰티", "놀이"])]
        }
    }

    func updateObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is PetKeywordData {
            return true
        } else {
            return false
        }
    }

    func deleteObject<T>(_ coreDataStructType: T) throws -> Bool where T: CoreDataStructEntity {
        if coreDataStructType is PetKeywordData {
            return true
        } else {
            return false
        }
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

class CoreDataTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInsertPetKeyword() {

    }

    func testFetchCoreData() {
        // given
        let pet = "강아지"

        // when
//        let result = service.fetchRecentSearchWord(pet: pet)
//
//        let count = mockSearchInfo.mockSearchWord.filter { $0.searchWord.contains(pet)
//        }.count
//        // then
//        XCTAssert(result!.count == count, "Fetch Fail")
    }

    func testInsert() {
    }

    func testUpdateCoreData() {

    }

    func testDeleteCoreData() {

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

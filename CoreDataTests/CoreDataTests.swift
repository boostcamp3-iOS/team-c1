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

class MyGoodsCoreDataTests: XCTestCase {
    let myGoodsManager = MockMyGoodsCoreDataManager()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInsertMyGoods() {
        let myGoodsData = MyGoodsData(pet: PetDefault.shared.pet.rawValue,
                                      title: "강아지 옷", link: "www.naver,com",
                                      image: "www.naver.com", isFavorite: true,
                                      isLatest: true, price: "12,000",
                                      productID: "12345", searchWord: "강아지 옷",
                                      shoppingmall: "네이버 쇼핑")

        myGoodsManager.insert(myGoodsData, completion: { (result, error) in
            if let error = error {
                XCTAssertNil(error, "에러가 발생했습니다.")
            } else {
                XCTAssert(result, "데이터를 저장할 수 없습니다.")
            }
            })
    }

    func testFetchFavoriteGoods() {
        myGoodsManager.fetchFavoriteGoods(pet: PetDefault.shared.pet.rawValue) { (myGoods, _) in
            XCTAssert(myGoods!.count > 0, "데이터가 존재하지 않습니다.")
        }

        myGoodsManager.fetchFavoriteGoods(pet: nil) { (myGoods, _) in
            XCTAssert(myGoods!.count > 0, "데이터가 존재하지 않습니다.")
        }
    }

    func testFetchLatestGoods() {
        myGoodsManager.fetchLatestGoods(pet:
            PetDefault.shared.pet.rawValue, isLatest: true, ascending: false) { (myGoodsData, _) in
                guard let myGoodsData = myGoodsData else {
                    return
                }
                let count = myGoodsData.filter { $0.isLatest == true}.count
                XCTAssert(count > 0, "Fetch Fatil")
        }
    }

    func testFetchProductID() {
        myGoodsManager.fetchProductID(productID: "123456") { (myGoods, _) in
            XCTAssertNotNil(myGoods, "Fetch Fail")
        }
    }

    func testDeleteFavoriteAllObjects() {
        myGoodsManager.deleteFavoriteAllObjects(pet:
            PetDefault.shared.pet.rawValue) { (result, _) in
                XCTAssert(result == true, "Delete Fail")
            }

    }

    func testDeleteLatestAllObjects() {
        myGoodsManager.deleteLatestAllObjects(pet:
            PetDefault.shared.pet.rawValue, isLatest: false) { (result, _) in
                XCTAssert(result, "Delete Fail")
            }
    }

    func testFetchObjects() {
        myGoodsManager.fetchObjects(pet: PetDefault.shared.pet.rawValue) { (myGoodsData, _) in
            guard let myGoodsData = myGoodsData else {
                return
            }
             XCTAssert(myGoodsData.count > 0, "Fetch Fail")
        }
    }

    func testUpdateObject() {
        let myGoodsData = MyGoodsData(pet: PetDefault.shared.pet.rawValue,
                                      title: "강아지 옷", link: "www.naver,com",
                                      image: "www.naver.com", isFavorite: true,
                                      isLatest: true, price: "12,000",
                                      productID: "12345", searchWord: "강아지 옷",
                                      shoppingmall: "네이버 쇼핑")

        myGoodsManager.updateObject(myGoodsData) { (result) in
            XCTAssert(result, "데이터르 업데이트 할 수 없습니다.")
        }

    }

    func testDeleteObject() {
        let myGoodsData = MyGoodsData(pet: PetDefault.shared.pet.rawValue,
                                      title: "강아지 옷", link: "www.naver,com",
                                      image: "www.naver.com", isFavorite: true,
                                      isLatest: true, price: "12,000",
                                      productID: "12345", searchWord: "강아지 옷",
                                      shoppingmall: "네이버 쇼핑")
        myGoodsManager.deleteObject(myGoodsData) { (result) in
                XCTAssert(result, "Delete Fail")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class PetKeywordCoreDataTests: XCTestCase {
    let petKeywordManager = MockPetKeywordCoreDataManager()

    override func setUp() { }

    func testInsert() {
        let petKeywordData = PetKeywordData(pet: PetDefault.shared.pet.rawValue, keywords: ["스타일", "뷰티", "리빙"])
        petKeywordManager.insert(petKeywordData, completion: { (result, error) in
            if let error = error {
                XCTAssertNil(error, "에러가 발생했습니다.")
            } else {
                XCTAssert(result, "데이터를 저장할 수 없습니다.")
            }
        })
    }

    func testFetchObjects() {
        petKeywordManager.fetchObjects(pet: nil) { (petKeyword, _) in
            guard let petKeyword = petKeyword else {
                return
            }
             XCTAssert(petKeyword.count >= 2, "FetchFail")
        }
    }

    func testFetchOnlyPet() {
        petKeywordManager.fetchOnlyPet { (pet, _) in
             XCTAssertNotNil(pet, "Fetch Fail")
        }
    }

    func testFetchOnlyKeyword() {
        petKeywordManager.fetchOnlyKeyword(pet: PetDefault.shared.pet.rawValue) { (keyword, _) in
            XCTAssertNotNil(keyword, "Fetch Fail")
        }
    }

    func testUpdate() {
        let petKeywordData = PetKeywordData(pet: PetDefault.shared.pet.rawValue, keywords: ["스타일", "뷰티", "리빙"])
        petKeywordManager.updateObject(petKeywordData) { (result) in
            XCTAssert(result, "데이터르 업데이트 할 수 없습니다.")
        }
    }

    func testDelete() {
        let petKeywordData = PetKeywordData(pet: PetDefault.shared.pet.rawValue, keywords: ["스타일", "뷰티", "리빙"])
        petKeywordManager.deleteObject(petKeywordData) {
                (result) in
                 XCTAssert(result, "delete fail")
        }
    }

    func testDeleteAll() {
        let petKeywordData = PetKeywordData(pet: PetDefault.shared.pet.rawValue, keywords: ["스타일", "뷰티", "리빙"])
        petKeywordManager.deleteAllObjects(pet: PetDefault.shared.pet.rawValue) {
            (result, _) in
            XCTAssert(result, "delete fail")
        }
    }
}

class SerarchWordCoreDataTests: XCTestCase {
    let searchWordManager = MockSearchWordCoreDataManager()

    override func setUp() {
    }

    func testInsertMyGoods() {
        let searchWord = SearchWordData(pet: PetDefault.shared.pet.rawValue, searchWord: "장난감")

        searchWordManager.insert(searchWord, completion: { (result, error) in
            if let error = error {
                XCTAssertNil(error, "에러가 발생했습니다.")
            } else {
                XCTAssert(result, "데이터를 저장할 수 없습니다.")
            }
        })
    }

    func testUpdate() {
        let searchWord = SearchWordData(pet: PetDefault.shared.pet.rawValue, searchWord: "화장실")
        searchWordManager.updateObject(searchWord) { (result) in
            XCTAssert(result, "데이터르 업데이트 할 수 없습니다.")
        }
    }

    func testFetchObject() {
        searchWordManager.fetchObjects(pet: PetDefault.shared.pet.rawValue) { (searchWorddata, error) in
            if let error = error {
                XCTAssertNil(error, "Fetch Object Error!! \(error)")
            } else {
                XCTAssertNotNil(searchWorddata, "Fail Fetch Object")
            }
        }
    }

    func testFetchObjectWhenPetNill() {
        searchWordManager.fetchObjects(pet: nil) { (searchWorddata, error) in
            if let error = error {
                XCTAssertNil(error, "Fetch Object Error!! \(error)")
            } else {
                XCTAssertNotNil(searchWorddata, "Fail Fetch Object")
            }
        }
    }

    func testFetchAllSearchWord() {
        searchWordManager.fetchOnlySearchWord(pet: PetDefault.shared.pet.rawValue) { (searchWords, error) in
            if let error = error {
                XCTAssertNil(error, "Fetch SearchWord Error!! \(error)")
            } else {
                XCTAssertNotNil(searchWords, "Fail Fetch SearchWord!!")
            }
        }
    }

    func testFetchSearchWord() {
        searchWordManager.fetchWord("고양이 옷", pet: "고양이") { (searchWordData, error) in
            if let error = error {
                XCTAssertNil(error, "Fetch Error!! \(error)")
            } else {
                XCTAssertNotNil(searchWordData, "Not found Data")
            }
        }
    }

    func testDelete() {
        let searchWord = SearchWordData(pet: PetDefault.shared.pet.rawValue, searchWord: "화장실")
        searchWordManager.deleteObject(searchWord) { (result) in
                XCTAssert(result, "Delete fail")
        }
    }

    func testAllDelete() {
        searchWordManager.deleteAllObjects(pet: PetDefault.shared.pet.rawValue) { (result, _) in
                XCTAssert(result, "Delete fail")
        }
    }
}

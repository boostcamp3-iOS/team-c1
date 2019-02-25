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
        do {
            let result = try myGoodsManager.insert(myGoodsData)
             XCTAssert(result, "데이터를 저장할 수 없습니다.")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func testFetchFavoriteGoods() {
        do {
            guard let petResult = try myGoodsManager.fetchFavoriteGoods(pet:
                PetDefault.shared.pet.rawValue) else {
                return
            }
            XCTAssert(petResult.count > 0, "데이터가 존재하지 않습니다.")
            guard let nonPetresult = try myGoodsManager.fetchFavoriteGoods(pet:
                nil) else {
                return
            }
            XCTAssert(nonPetresult.count > 0, "데이터가 존재하지 않습니다.")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func testFetchLatestGoods() {
        do {
            guard let result = try myGoodsManager.fetchLatestGoods(pet:
                PetDefault.shared.pet.rawValue, isLatest: true, ascending: false) else {
                return
            }
            let count = result.filter { $0.isLatest == true}.count
            XCTAssert(count > 0, "Fetch Fatil")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func testFetchProductID() {
        let result = myGoodsManager.fetchProductID(productID: "123456")
        XCTAssertNotNil(result, "Fetch Fail")

    }

    func testDeleteFavoriteAllObjects() {
        do {
            let result = try myGoodsManager.deleteFavoriteAllObjects(pet:
                PetDefault.shared.pet.rawValue)
            XCTAssert(result == true, "Delete Fail")
        } catch let error {
            print(error.localizedDescription)
        }

    }

    func testDeleteLatestAllObjects() {
        do {
            let result = try myGoodsManager.deleteLatestAllObjects(pet:
                PetDefault.shared.pet.rawValue, isLatest: false)
            XCTAssert(result, "Delete Fail")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func testFetchObjects() {
        do {
            guard let result = try myGoodsManager.fetchObjects(pet:
                PetDefault.shared.pet.rawValue) else {
                return
            }
            XCTAssert(result.count > 0, "Fetch Fail")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func testUpdateObject() {
        let myGoodsData = MyGoodsData(pet: PetDefault.shared.pet.rawValue,
                                      title: "강아지 옷", link: "www.naver,com",
                                      image: "www.naver.com", isFavorite: true,
                                      isLatest: true, price: "12,000",
                                      productID: "12345", searchWord: "강아지 옷",
                                      shoppingmall: "네이버 쇼핑")
        do {
            let result = try myGoodsManager.updateObject(myGoodsData)
            XCTAssertNotNil(result, "Update Fail")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func testDeleteObject() {
        let myGoodsData = MyGoodsData(pet: PetDefault.shared.pet.rawValue,
                                      title: "강아지 옷", link: "www.naver,com",
                                      image: "www.naver.com", isFavorite: true,
                                      isLatest: true, price: "12,000",
                                      productID: "12345", searchWord: "강아지 옷",
                                      shoppingmall: "네이버 쇼핑")
        do {
            let result = try myGoodsManager.deleteObject(myGoodsData)
            XCTAssert(result, "Delete Fail")
        } catch let error {
            print(error.localizedDescription)
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

    override func setUp() {
    }

    func testInsert() {
        let petKeywordData = PetKeywordData(pet: PetDefault.shared.pet.rawValue, keywords: ["스타일", "뷰티", "리빙"])
        do {
            let result = try petKeywordManager.insert(petKeywordData)
            XCTAssert(result, "Insert Fail")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func testFetchObjects() {
        do {
            guard let result = try petKeywordManager.fetchObjects(pet: nil) else {
                return
            }
            XCTAssert(result.count >= 2, "FetchFail")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func testFetchOnlyPet() {
        do {
            let result = try petKeywordManager.fetchOnlyPet()
            XCTAssertNotNil(result, "Fetch Fail")
        } catch let error {
             print(error.localizedDescription)
        }
    }

    func testFetchOnlyKeyword() {

        do {
            guard let result = try petKeywordManager.fetchOnlyKeyword(pet: PetDefault.shared.pet.rawValue) else {
            return
            }
            XCTAssertNotNil(result, "Fetch Fail")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func testUpdate() {
        let petKeywordData = PetKeywordData(pet: PetDefault.shared.pet.rawValue, keywords: ["스타일", "뷰티", "리빙"])
        do {
            let result = try petKeywordManager.updateObject(petKeywordData)
            XCTAssert(result, "update Fail")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func testDelete() {
        let petKeywordData = PetKeywordData(pet: PetDefault.shared.pet.rawValue, keywords: ["스타일", "뷰티", "리빙"])
        do {
            let result = try petKeywordManager.deleteObject(petKeywordData)
            XCTAssert(result, "delete fail")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func testDeleteAll() {
        let petKeywordData = PetKeywordData(pet: PetDefault.shared.pet.rawValue, keywords: ["스타일", "뷰티", "리빙"])
        do {
            let result = try petKeywordManager.deleteAllObjects(pet: PetDefault.shared.pet.rawValue)
            XCTAssert(result, "delete fail")
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

class SearchWordCoreDataTests: XCTestCase {
     let searchWordManager = MockSearchWordCoreDataManager()

    //func updateObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool
    override func setUp() {

    }

    func testInsert() {
        let searchWordData = SearchWordData(pet: PetDefault.shared.pet.rawValue, searchWord: "\(PetDefault.shared.pet.rawValue) 옷")
        do {
            let result = try searchWordManager.insert(searchWordData)
            XCTAssert(result, "Indsert Fail")
        } catch let error {
            print(error.localizedDescription)
        }

    }

    func testFetchObjects() {
        do {
            guard let result = try searchWordManager.fetchObjects(pet: PetDefault.shared.pet.rawValue) else {
                return
            }
            XCTAssert(result.count > 0, "Fetch Fail")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func testFetchOnlySearchWord() {
        do {
            guard let result = try searchWordManager.fetchOnlySearchWord(pet: PetDefault.shared.pet.rawValue) else {
                return
            }
            XCTAssert(result.count >= 2, "Fetch Fail")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func testUpdate() {
        let searchWordData = SearchWordData(pet: PetDefault.shared.pet.rawValue, searchWord: "\(PetDefault.shared.pet.rawValue) 옷")
        do {
            let result = try searchWordManager.updateObject(searchWordData)
            XCTAssert(result, "Update Fail")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func testDeleta() {
        let searchWordData = SearchWordData(pet: PetDefault.shared.pet.rawValue, searchWord: "\(PetDefault.shared.pet.rawValue) 옷")
        do {
            let result = try searchWordManager.updateObject(searchWordData)
            XCTAssert(result, "Delete Fail")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func testDeleteAll() {
        do {
            let result = try searchWordManager.deleteAllObjects(pet: PetDefault.shared.pet.rawValue)
            XCTAssert(result, "Delete Fail")
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

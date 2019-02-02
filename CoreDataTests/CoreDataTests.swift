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
    var mockSearchWordCoreData = [SearchWordData]()
    var mockSearchWord: [String]?
    
    @discardableResult func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool{
        let beforeCount = mockSearchWordCoreData.count
        let  afterCount = mockSearchWordCoreData.count
        guard let coreDataStruct = coreDataStructType as? SearchWordData else {
            return false
        }
        mockSearchWordCoreData.append(coreDataStruct)
        return beforeCount + 1 == afterCount ? true : false
    }
    
    func fetchOnlySearchWord() throws -> [String]? {
        return MockSearchWordInfo.mockSearchWord
    }
    
    func fetchObjects() throws -> [CoreDataStructEntity]? {
        return nil
    }
    
    func updateObject<T>(_ coreDataStructType: T) throws -> Bool {
        return false
    }
    
    func deleteObject<T>(_ coreDataStructType: T) throws -> Bool {
        return false
    }
}

class MockSearchWordInfo {
    static let mockSearchWord = ["강아지 옷", "강아지 간식", "강아지 사료", "고양이 옷"]
}

class MockPetKeywordCoreDataManager: PetKeywordCoreDataManagerType {
    func fetchOnlyKeyword() throws -> [String]? {
        return nil
    }
    
    func fetchOnlyPet() throws -> String? {
        return nil
    }
    
    func insert<T>(_ coreDataStructType: T) throws -> Bool {
        return false
    }
    
    func fetchObjects() throws -> [CoreDataStructEntity]? {
         return nil
    }
    
    func updateObject<T>(_ coreDataStructType: T) throws -> Bool {
        return false
    }
    
    func deleteObject<T>(_ coreDataStructType: T) throws -> Bool {
        return false
    }
}

class MockMyGoodsCoreDataManager: MyGoodsCoreDataManagerType {
    func fetchFavoriteGoods() throws -> [MyGoodsData]? {
         return nil
    }
    
    func fetchLatestGoods() throws -> [MyGoodsData]? {
         return nil
    }
    
    func insert<T>(_ coreDataStructType: T) throws -> Bool {
        return false
    }
    
    func fetchObjects() throws -> [CoreDataStructEntity]? {
        return nil
    }
    
    func updateObject<T>(_ coreDataStructType: T) throws -> Bool {
        return false
    }
    
    func deleteObject<T>(_ coreDataStructType: T) throws -> Bool {
        return false
    }
    
}


class CoreDataTests: XCTestCase {

    let mockSearchWordCoreDataManager = MockSearchWordCoreDataManager()
    let mockPetKeywordCoreDataManager = MockPetKeywordCoreDataManager()
    let mockNWManager = MockShoppingNetworkManager()
    
    lazy var service = SearchService(serachCoreData: mockSearchWordCoreDataManager,
                                     petCoreData: mockPetKeywordCoreDataManager,
                                     network: mockNWManager)
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchCoreData() {
        // given
        mockSearchWordCoreDataManager.mockSearchWord = MockSearchWordInfo.mockSearchWord
        
        // when
        let result = service.fetchRecentSearchWord()
        
        // then
        XCTAssert(result!.count == MockSearchWordInfo.mockSearchWord.count , "Fetch Fail")
    }
    
    func testInsert() {
        // given
        service.insert(recenteSearchWord: "고양이 옷")
        do {
            // when
            let result = try mockSearchWordCoreDataManager.fetchOnlySearchWord()
            guard let nonOpResult = result else { return }
            //then
            XCTAssert(nonOpResult.contains("고양이 옷"), "InsertFail")
        } catch let error {
            print(error)
        }
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

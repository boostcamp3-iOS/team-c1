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

//class MockCoreDataManager: CoreDataManagerType{
//    
//}

class MockSearchKeywordCoreDataManager: SearchKeywordCoreDataManagerType {
    
    func fetchOnlySearchWord() -> [String]? {
        return []
    }
    
    
    var strSearch: [String]! //= ["강아지 옷", "강아지 간식", "강아지 사료"]
    func fetch<T>(_ coreDataType: T.Type, sortBy: [NSSortDescriptor]?, predicate: NSPredicate?) throws -> [T]? where T : CoreDataEntity {
        return []
    }
    
    func insertCoreData<T>(_ coreDataType: T) throws -> Bool where T : CoreDataEntity {
        
    }
    
    func deleteObject<T>(_ entityClass: T.Type, predicate: NSPredicate?) throws -> Bool where T : NSManagedObject {
        
    }
    
    func updateObject<T>(_ coreDataType: T) throws -> Bool where T : CoreDataEntity {
        
    }
}

class MockSearchKeywordInfo {
    static let strSearch = ["강아지 옷", "강아지 간식", "강아지 사료"]
}

class MockPetKeywordCoreDataManager: PetKeywordCoreDataManagerType {
    func fetchOnlyKeyword() throws -> [String]? {
        return []
    }
    
    func fetch<T>(_ coreDataType: T.Type, sortBy: [NSSortDescriptor]?, predicate: NSPredicate?) throws -> [T]? where T : CoreDataEntity {
        return []
    }
    
    func insertCoreData<T>(_ coreDataType: T) throws -> Bool where T : CoreDataEntity {
        
    }
    
    func deleteObject<T>(_ entityClass: T.Type, predicate: NSPredicate?) throws -> Bool where T : NSManagedObject {
        
    }
    
    func updateObject<T>(_ coreDataType: T) throws -> Bool where T : CoreDataEntity {
        
    }
    
}

class CoreDataTests: XCTestCase {

    let mockSearchKeywordCoreDataManager = MockSearchKeywordCoreDataManager()
    let mockPetKeywordCoreDataManager = MockPetKeywordCoreDataManager()
    let mockNWManager = MockShoppingNetworkManager()
    
    lazy var service = SearchService(serachCoreData: mockSearchKeywordCoreDataManager,
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
        mockSearchKeywordCoreDataManager.strSearch = MockSearchKeywordInfo.strSearch
        
        // when
        let result = service.fetchRecentSearchWord()
        
        // then
        XCTAssert(result.count == MockSearchKeywordInfo.strSearch.count , "Fetch Fail")
    }
    
    func testInsert() {
//        2. insert(recentSearchWord: String) -> Void
        service.insert(recenteSearchWord: "고양이")
        let result = mockPetKeywordCoreDataManager.fetchOnlyKeyword()
        
        result?.contains("고양이")
//        mockCoreDataManager.fetch(<#T##coreDataType: CoreDataEntity.Protocol##CoreDataEntity.Protocol#>, sortBy: <#T##[NSSortDescriptor]?#>, predicate: <#T##NSPredicate?#>)
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

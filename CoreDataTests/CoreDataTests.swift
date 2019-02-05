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
    var mockSearchInfo = MockSearchWordInfo()
    
    @discardableResult func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool{
        let beforeCount = mockSearchInfo.mockSearchWord.count
        guard let coreDataStruct = coreDataStructType as? SearchWordData else {
            return false
        }
        print(coreDataStruct)
        mockSearchInfo.mockSearchWord.append(coreDataStruct)
        let afterCount = mockSearchInfo.mockSearchWord.count
        return beforeCount + 1 == afterCount ? true : false
    }
    
    func fetchOnlySearchWord(pet: String) throws -> [String]? {
        let result = mockSearchInfo.mockSearchWord.filter{ $0.searchWord.contains(pet)
        }
        var stringResult = [String]()
        for value in result {
            stringResult.append(value.searchWord)
        }
        return stringResult
    }
    
    func fetchObjects(pet: String? = nil) throws -> [CoreDataStructEntity]? {
        if pet != nil {
            let result = mockSearchInfo.mockSearchWord.filter{ $0.searchWord.contains(pet!)
            }
            return result
        }
        return mockSearchInfo.mockSearchWord
    }
    
    
    func updateObject<T>(_ coreDataStructType: T) throws -> Bool {
        guard let searchWordData = coreDataStructType as? SearchWordData else {
            return false
        }
        let mockSearchWords = mockSearchInfo.mockSearchWord
        let object = mockSearchWords.filter { (searchWord) -> Bool in
            if searchWord.searchWord == searchWordData.searchWord {
                return true
            }
            return false
        }
        guard var result = object.first else { return false }
        result.date = searchWordData.date
        return false
    }
    
    @discardableResult func updateObject(with searchWord: String, pet: String) throws -> Bool {
        var result = false
        do {
            guard let objects = try fetchObjects(pet: pet) as? [SearchWordData] else { return false }
            let object = objects.filter { $0.searchWord == searchWord }
            if var first = object.first {
                first.date = mockSearchInfo.createDate()
                mockSearchInfo.mockSearchWord.append(first)
                let newResult = mockSearchInfo.mockSearchWord
                print("mockCount: \(mockSearchInfo.mockSearchWord.count)")
                result = true
            }
        }
        return result
    }
    
    func deleteObject<T>(_ coreDataStructType: T) throws -> Bool {
        guard let searchWordData = coreDataStructType as? SearchWordData else {
            return false
        }
        var index = 0
        for object in mockSearchInfo.mockSearchWord {
            if object.objectID == searchWordData.objectID {
                break
            }
            index = index + 1
        }
        mockSearchInfo.mockSearchWord.remove(at: index)
        return false
    }
    
    @discardableResult func deleteAllObjects(pet: String) throws ->  Bool {
        let nonDeleteObjects = mockSearchInfo.mockSearchWord.filter { $0.pet
            != pet }
        mockSearchInfo.mockSearchWord.removeAll()
        mockSearchInfo.mockSearchWord = nonDeleteObjects
        print(mockSearchInfo.mockSearchWord)
        do {
            guard let result = try fetchObjects(pet: pet) else { return false }
            if result.count == 0 {
                return true
            }
        }
    
        return false
    }
}

class MockSearchWordInfo {
    var mockSearchWord: [SearchWordData] = {
        var searchWordDatas = [SearchWordData]()
        var searchWordData1 = SearchWordData()
        searchWordData1.date = searchWordData1.createDate()
        searchWordData1.searchWord = "고양이 옷"
        searchWordData1.pet = "고양이"
       // searchWordData1.objectID = NSManagedObjectID()
        var searchWordData2 = SearchWordData()
        searchWordData2.date = searchWordData2.createDate()
        searchWordData2.searchWord = "고양이 장난감"
        searchWordData2.pet = "고양이"
       // searchWordData2.objectID = NSManagedObjectID()
        var searchWordData3 = SearchWordData()
        searchWordData3.date = "2019-01-02"
        searchWordData3.searchWord = "강아지 장난감"
        searchWordData3.pet = "강아지"
       // searchWordData3.objectID = NSManagedObjectID()
        
        searchWordDatas.append(searchWordData1)
        searchWordDatas.append(searchWordData2)
        searchWordDatas.append(searchWordData3)
        return searchWordDatas
    }()
    
    func createDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}

class MockPetKeywordCoreDataManager: PetKeywordCoreDataManagerType {
    func fetchOnlyKeyword(pet: String) throws -> [String]? {
        return nil
    }
    
    func fetchOnlyPet(pet: String) throws -> String? {
        return nil
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
    
    @discardableResult func deleteAllObjects(pet: String) throws -> Bool {
        return false
    }
}

class MockMyGoodsCoreDataManager: MyGoodsCoreDataManagerType {
    func fetchFavoriteGoods(pet: String) throws -> [MyGoodsData]? {
         return nil
    }
    
    func fetchLatestGoods(pet: String) throws -> [MyGoodsData]? {
         return nil
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
    
    @discardableResult func deleteLatestAllObjects(pet: String, isLatest: Bool) throws -> Bool {
        return false
    }
    
}


class CoreDataTests: XCTestCase {

    let mockSearchWordCoreDataManager = MockSearchWordCoreDataManager()
    let mockPetKeywordCoreDataManager = MockPetKeywordCoreDataManager()
    let mockNWManager = MockShoppingNetworkManager()
    var mockSearchInfo = MockSearchWordInfo()
    
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
        let pet = "강아지"
        
        // when
        let result = service.fetchRecentSearchWord(pet: pet)
        
        let count = mockSearchInfo.mockSearchWord.filter{ $0.searchWord.contains(pet)
        }.count
        // then
        XCTAssert(result!.count == count , "Fetch Fail")
    }
    
    func testInsert() {
        let pet = "강아지"
        let searchWord = "강아지 한복"
    
        // given
        service.insert(recenteSearchWord: searchWord, pet: pet)
        do {
            // when
            let result = try mockSearchWordCoreDataManager.fetchOnlySearchWord(pet: pet)
            guard let nonOpResult = result else { return }
            print(nonOpResult)
            //then
            XCTAssert(nonOpResult.contains(searchWord), "InsertFail")
        } catch let error {
            print(error)
        }
    }
    
    func testUpdateCoreData() {
        let pet = "강아지"
        let searchWord = "강아지 장난감"
        let beforeCount = mockSearchInfo.mockSearchWord.filter { $0.pet == pet }.count
        //given
        service.updateRecentSearchWord(searchWord: searchWord, pet: pet)
        do {
            // when
            guard let result = try mockSearchWordCoreDataManager.fetchObjects(pet: pet) as? [SearchWordData] else { return }
            // then : 원래 로직은 기존의 값을 업데이트 하지만 테스트는 같은 값을 하나 더 넣기 때문에 카운트로 비교
             XCTAssert(beforeCount != result.count, "Update Fail")
        } catch let error {
            print(error)
        }
    }
    
    func testDeleteCoreData() {
        let pet = "강아지"
        //given
        let result = service.deleteRecentSearchWord(pet: pet)
        var count = 0
        //when
        do {
            guard let object = try mockSearchWordCoreDataManager.fetchObjects(pet: pet) else { return }
            count = object.count
        } catch let error {
            print(error)
        }
        //then
        XCTAssert(count == 0, "Delete Fail")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

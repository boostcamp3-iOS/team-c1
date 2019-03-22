//
//  SettingPetAndKeywordServiceTests.swift
//  SettingPetAndKeywordServiceTests
//
//  Created by 이호찬 on 22/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import XCTest
@testable import CoCo

class SettingPetAndKeywordServiceTests: XCTestCase {

    let settingService = SettingPetAndKeywordService(petCoreData: MockPetKeywordCoreDataManager())

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testFetchPetKeywordData() {
        settingService.fetchPetKeywordData { [weak self](error) in
            if let error = error {
                XCTAssertNil(error, "Insert Error")
            }
                XCTAssert(self?.settingService.petKeyword?.pet == "강아지", "데이터 없음")

        }
    }

    func testInsertPetKeywordData() {
        settingService.petKeyword = MockPetKeywordCoreDataDummy.petKeywordData
        settingService.insertPetKeywordData { (error) in
            if let error = error {
                XCTAssertNil(error, "Insert Error")
            }
                 XCTAssert(PetDefault.shared.pet.rawValue == MockPetKeywordCoreDataDummy.petKeywordData.pet ?? "강아지", "강아지 인서트 오류")

        }
    }

    func testInsertPetKeywordDataNil() {
        settingService.petKeyword?.pet = nil
        settingService.petKeyword?.keywords = nil
        settingService.insertPetKeywordData { (error) in
            if let error = error {
                XCTAssertNil(error, "Insert Error")
            }
                XCTAssert(PetDefault.shared.pet.rawValue == MockPetKeywordCoreDataDummy.petKeywordData.pet ?? "강아지", "강아지 인서트 오류")

        }
    }
}

class MockPetKeywordCoreDataManager: PetKeywordCoreDataManagerType {
    func fetchObjects(pet: String?, completion: @escaping ([CoreDataStructEntity]?, Error?) -> Void) {
        if let pet = pet {
            completion([PetKeywordData(pet: pet, keywords: ["배변", "뷰티", "놀이"])], nil)
        } else {
            completion([PetKeywordData(pet: "강아지", keywords: ["배변", "뷰티", "놀이"]), PetKeywordData(pet: "고양이", keywords: ["배변", "뷰티", "놀이"])], nil)
        }
    }

    func fetchOnlyKeyword(pet: String, completion: @escaping (([String]?, Error?) -> Void)) {
        completion(["배변", "놀이", "뷰티", "스타일"], nil)
    }

    func fetchOnlyPet(completion: @escaping (String?, Error?) -> Void) {
        completion("고양이", nil)
    }

    func deleteAllObjects(pet: String) throws -> Bool {
        if pet == "고양이" || pet == "강아지" {
            return true
        } else {
            return false
        }
    }

    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T, completion: @escaping (Bool, Error?) -> Void) {
        if let petKeyword = coreDataStructType as? PetKeywordData {
            guard let keyword = petKeyword.keywords else {
                return
            }
            if keyword.count >= 2 {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        } else {
            completion(false, nil)
        }
    }

    func updateObject<T>(_ coreDataStructType: T, completion:@escaping
        (Bool) -> Void) {
        if coreDataStructType is PetKeywordData {
            completion(true)
        } else {
            completion(false)
        }
    }

    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T)
        throws -> Bool {
            if coreDataStructType is PetKeywordData {
                return true
            } else {
                return false
            }
    }

}

class MockPetKeywordCoreDataDummy {
    static let petKeywordData = PetKeywordData(pet: "강아지", keywords: ["배변", "뷰티", "놀이"])
    static let failPetKeywordData: PetKeywordData? = nil
}

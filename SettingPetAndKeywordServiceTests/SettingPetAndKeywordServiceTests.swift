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
        settingService.fetchPetKeywordData()
        XCTAssert(settingService.petKeyword?.pet == "강아지", "데이터 없음")
    }

    func testInsertPetKeywordData() {
        settingService.petKeyword = MockPetKeywordCoreDataDummy.petKeywordData
        settingService.insertPetKeywordData()
        XCTAssert(PetDefault.shared.pet.rawValue == MockPetKeywordCoreDataDummy.petKeywordData.pet ?? "강아지", "강아지 인서트 오류")
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

class MockPetKeywordCoreDataDummy {
    static let petKeywordData = PetKeywordData(pet: "강아지", keywords: ["배변", "뷰티", "놀이"])
    static let failPetKeywordData: PetKeywordData? = nil
}

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

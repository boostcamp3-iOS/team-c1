//
//  SearchServiceTests.swift
//  SearchServiceTests
//
//  Created by 이호찬 on 21/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import XCTest
@testable import CoCo
@testable import NetworkTests

class SearchServiceTests: XCTestCase {

    let searchService = SearchService(serachCoreData: SearchWordCoreDataManager(), petCoreData: PetKeywordCoreDataManager(), network: MockShoppingNetworkManager.shared, algorithm: Algorithm())

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

    func testGetShoppingData() {
        searchService.getShoppingData(search: "") { isSuccess, _ in
            if isSuccess {
                XCTAssert(self.searchService.dataLists.count == 20)
            }
        }
    }

}

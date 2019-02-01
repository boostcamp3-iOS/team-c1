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

    let mockCoreDataManager = MockCoreDataManager()
    let mockNWManager = MockShoppingNetworkManager()
    
    lazy var service = SearchService(core: mockCoreDataManager, network: mockNWManager)
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInsertMyGoodsCoreData() {
        let myGoodsData = MyGoodsData()
        do {
            let result = try mockCoreDataManager.insertCoreData(myGoodsData)
            XCTAssert(result, "Insert Fail")
        } catch let error {
            print(error)
        }
    }
    
    func testFetchCoreData() {
        let result = service.fetchRecentSearchWord()
        XCTAssert(result.count == 4 , "Fetch Fail")
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

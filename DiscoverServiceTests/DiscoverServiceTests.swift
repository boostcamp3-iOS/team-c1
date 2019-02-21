//
//  DiscoverServiceTests.swift
//  DiscoverServiceTests
//
//  Created by 강준영 on 21/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import XCTest
import CoreData
@testable import CoreDataTests
@testable import CoCo

class DiscoverServiceTests: XCTestCase {

    private let networkManagerType = ShoppingNetworkManager.shared
    private let algorithmManager = Algorithm()
    private let searchWordCoreDataManager = MockSearchWordCoreDataManager()
    private var myGoodsCoreDataManager = MyGoods()
    private var petKeywordCoreDataManager = PetKeywordCoreDataManager()
    
    let discoverService = DiscoverService(networkManagerType: networkManagerType, algorithmManagerType: algorithmManager, searchWordDoreDataManagerType: searchWordCoreDataManager, myGoodsCoreDataManagerType: myGoodsCoreDataManager, petKeywordCoreDataManagerType: petKeywordCoreDataManager)
    
    
    
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

}

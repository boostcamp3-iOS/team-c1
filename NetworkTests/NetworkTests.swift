//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by 이호찬 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import XCTest
@testable import CoCo

class NetworkTests: XCTestCase {

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

    func testGetAPIData() {
        let params = MockShoppingNetworkManagerDummy.params
        MockShoppingNetworkManager.shared.getAPIData(params, completion: { data in
            let a = data.items
            XCTAssert(a.count == 20)
        }) { err in
            print(err)
        }
    }
}

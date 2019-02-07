//
//  AlgorithmTests.swift
//  AlgorithmTests
//
//  Created by 이호찬 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import XCTest
@testable import CoCo

class AlgorithmTests: XCTestCase {

    var algorithm: AlgorithmType!
    let pet = Pet.dog
    let detailCategories = ["패딩/아우터", "올인원/원피스"]
    let searchWords = ["패딩", "아우터", "올인원", "원피스"]
    let combineSearchWords = ["강아지 패딩", "강아지 아우터", "강아지 올인원", "강아지 원피스"]

    override func setUp() {
        algorithm = Algorithm()
    }

    override func tearDown() {
    }

    func testPetIncluded() {
        XCTAssertTrue(algorithm.petIncluded(in: pet.rawValue + searchWords.first!),
                      "실패: testPetIncluded()")
    }

    func testMakeSearchWords() {
        XCTAssertEqual(algorithm.makeSearchWords(in: detailCategories, count: 10).count, searchWords.count,
                       "실패: testMakeSearchWords()")
    }

    func testCombinePet() {
        XCTAssertEqual(
            algorithm.combinePet(pet, and: searchWords), combineSearchWords,
            "실패: testCombinePet()")
    }

    func testRemovePet() {
        XCTAssertEqual(algorithm.removePet(from: combineSearchWords), searchWords,
                       "실패: testRemovePet()")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

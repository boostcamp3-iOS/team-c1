//
//  AlgorithmTests.swift
//  AlgorithmTests
//
//  Created by 최영준 on 21/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import XCTest
@testable import CoCo

class AlgorithmTests: XCTestCase {

    var algorithmManager: AlgorithmType!
    var myGoods = [MyGoodsData]()
    var words = [String]()
    var petKeyword: PetKeywordData!

    override func setUp() {
        algorithmManager = Algorithm()
        for i in 1 ... 10 {
            let goods = MyGoodsData(pet: "강아지", title: "", link: "", image: "", isFavorite: false, isLatest: false, price: "", productID: "", searchWord: "검색단어 \(i)", shoppingmall: "")
            myGoods.append(goods)
        }
        words = [
            "사료/간식", "장난감/훈련/놀이", "미용", "옷/패션/스타일", "쿠션/하우스", "건강", "관리"
        ]
        petKeyword = PetKeywordData(pet: Pet.dog.rawValue, keywords: [Keyword.beauty.rawValue, Keyword.style.rawValue, Keyword.food.rawValue])
    }

    override func tearDown() {
        algorithmManager = nil
        myGoods.removeAll()
        words.removeAll()
        petKeyword = nil
    }

    // MARK: WordType Test
    /*
     func petIncluded(in word: String) -> Bool
     func combinePet(_ pet: Pet, and words: [String]) -> [String]
     func combinePet(_ pet: Pet, and word: String) -> String
     func removePet(from words: [String]) -> [String]
     func removePet(from word: String) -> String
     func removeHTML(from string: String) -> String
     func replaceNewLine(from string: String) -> String
     func addComma(to string: String) -> String
     */

    func testPetIncluded() {
        let input = "고양이 집"
        let result = algorithmManager.petIncluded(in: input)
        XCTAssert(result, "testPetIncluded 실패")
    }

    func testCombinePet() {
        let input = ["사료", "장난감", "집", "양말"]
        let expectedResult = ["고양이 사료", "고양이 장난감", "고양이 집", "고양이 양말"]
        let result = algorithmManager.combinePet(.cat, and: input)
        XCTAssert(expectedResult == result, "testCombinePet 실패")
    }

    func testRemovePet() {
        let input = ["강아지 사료", "고양이 장난감", "강아지집", "고양이양말"]
        let expectedResult = ["사료", "장난감", "집", "양말"]
        let result = algorithmManager.removePet(from: input)
        XCTAssert(expectedResult == result, "testRemovePet 실패")
    }

    func testRemoveHTML() {
        let input = "<span class=\"s1\"><b>Contact Us</b></span></p>"
        let expectedResult = "Contact Us"
        let result = algorithmManager.removeHTML(from: input)
        XCTAssert(expectedResult == result, "testRemoveHTML 실패")
    }

    func testReplaceNewLine() {
        let input = "테스트</b>입니다."
        let expectedResult = "테스트 입니다."
        let result = algorithmManager.replaceNewLine(from: input)
        XCTAssert(expectedResult == result, "testReplaceNewLine 실패")
    }

    func testAddComma() {
        let input = "10000000"
        let expectedResult = "10,000,000"
        let result = algorithmManager.addComma(to: input)
        XCTAssert(expectedResult == result, "testAddComma 실패")
    }

    // MARK: - MakeSearchWordsType
    /*
     func makeRequestSearchWords(with myGoods: [MyGoodsData], words: [String], petKeyword: PetKeywordData, count: UInt?) -> [String]
     func makeRecommendedSearchWords(with words: [String], petKeyword: PetKeywordData, count: UInt?) -> [String]
     func makeSearchWords(in words: [String], count: UInt?) -> [String]
     func makeSearchWords(_ word: String) -> [String]
     func makeCleanTitle(_ title: String, isReplacing: Bool) -> String
     */

    func testMakeRequestSearchWords() {
        let count: UInt = 10
        let result = algorithmManager.makeRequestSearchWords(with: myGoods, words: words, petKeyword: petKeyword, count: count)
        XCTAssert(result.count == count, "testMakeRequestSearchWords 실패")
    }

    func testMakeRecommendedSearchWords() {
        let count: UInt = 10
        let result = algorithmManager.makeRecommendedSearchWords(with: words, petKeyword: petKeyword, count: count)
        XCTAssert(result.count == count, "testMakeRecommendedSearchWords 실패")
    }

    func testMakeSearchWords() {
        let count: UInt = 5
        let result = algorithmManager.makeSearchWords(in: words, count: count)
        XCTAssert(result.count == count, "testMakeSearchWords 실패")
    }

    func testMakeCleanTitle() {
        let input = "<span class=\"s1\"><b>Contact Us</b></span></p><b>010-1111-1234</b>부스트캠프"
        let expectedResult = "Contact Us 010-1111-1234 부스트캠프"
        let result = algorithmManager.makeCleanTitle(input, isReplacing: true)
        XCTAssert(expectedResult == result, "testMakeCleanTitle 실패")
    }

    // MARK: - PaginationType
    /*
     func setPagination(once: Int, maximum: Int)
     func setRecommendedPagination(words: [String], once: Int, maximum: Int)
     func pagination(index: Int, completion: @escaping (_ isSuccess: Bool, _ startIndex: Int?) -> Void)
     func recommendedPagination(index: Int, completion: @escaping (_ isSuccess: Bool, _ startIndex: Int?, _ words: String?) -> Void)
     */

    func testPagination() {
        let once = 10
        let maximum = 100
        var expectedStartIndex: Int = once
        algorithmManager.setPagination(once: once, maximum: maximum)
        for start in 0 ..< maximum {
            algorithmManager.pagination(index: start) { (isSuccess, startIndex) in
                if isSuccess, let startIndex = startIndex {
                    XCTAssert(isSuccess == true && startIndex == expectedStartIndex, "testPagination 실패")
                    expectedStartIndex += once
                }
            }
        }
    }

    func testRecommendedPagination() {
        let once = 20
        let maximum = 100
        var expectedStartIndex: Int = once
        let words = ["사료", "간식", "방석", "하우스", "옷", "신발", "패션", "장난감", "놀이"]
        algorithmManager.setRecommendedPagination(words: words, once: once, maximum: maximum)
        for start in 0 ..< maximum {
            algorithmManager.recommendedPagination(index: start) { (isSuccess, startIndex, searchWord) in
                if isSuccess, let startIndex = startIndex, let searchWord = searchWord {
                    XCTAssert(isSuccess == true && startIndex == expectedStartIndex && words.contains(searchWord), "testPagination 실패")
                    expectedStartIndex += once
                }
            }
        }
    }
}

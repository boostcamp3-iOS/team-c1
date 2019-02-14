//
//  Algorithm.swift
//  CoCo
//
//  Created by 최영준 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

class Algorithm: AlgorithmType {
    /**
     PetKeywordData에 포함된 상세 카테고리를 추출한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameters:
        - petKeyword: 사용자 관심 펫, 키워드 PetKeywordData
     */
    func extractDetailCategories(_ petKeyword: PetKeywordData) -> [String] {
        var result = [String]()
        guard let pet = petKeyword.pet, let keywords = petKeyword.keywords else {
            return []
        }
        for keyword in keywords {
            for category in keyword.getData() {
                result += category.getData(pet: pet)
            }
        }
        return result
    }
}

// MARK: - MakeSearchWordsType
extension Algorithm {
    /**
     둘러보기 페이지에서 네이버 쇼핑 검색 서비스 API에 전달할 쿼리를 생성한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameters:
        - myGoods: 찜한 상품 + 최근 본 상품 리스트 [MyGoodsData]
        - words: 최근 검색한 검색어 리스트
        - petKeyword: 관심 펫, 키워드 데이터: PetKeywordData
        - count: 받아올 개수, 입력하지 않으면 전체 데이터를 반환한다.
     */
    func makeRequestSearchWords(with myGoods: [MyGoodsData], words: [String], petKeyword: PetKeywordData, count: UInt? = nil) -> [String] {
        var products = Set<String>()
        var searchWords = myGoods.compactMap { $0.searchWord }
        searchWords += words
        searchWords += extractDetailCategories(petKeyword)
        searchWords.shuffle()
        searchWords = makeSearchWords(in: searchWords)
        for searchWord in searchWords {
            if let count = count, products.count >= count {
                break
            }
            products.insert(searchWord)
        }
        return Array(products)
    }
    /**
     검색 페이지에서 사용자에게 보여줄 추천 검색어를 생성한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameters:
        - words: 최근 검색한 검색어 리스트
        - petKeyword: 관심 펫, 키워드 데이터: PetKeywordData
        - count: 받아올 개수, 입력하지 않으면 전체 데이터를 반환한다.
     */
    func makeRecommendedSearchWords(with words: [String], petKeyword: PetKeywordData, count: UInt? = nil) -> [String] {
        var products = Set<String>()
        var searchWords = words
        searchWords += extractDetailCategories(petKeyword)
        searchWords.shuffle()
        searchWords = makeSearchWords(in: searchWords)
        for searchWord in searchWords {
            if let count = count, products.count >= count {
                break
            }
            products.insert(searchWord)
        }
        return Array(products)
    }
    /**
     문자열 리스트에서 지정된 개수의 검색어를 생성한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameters:
        - words: 단어 리스트
        - count: 받아올 개수, 기본값은 10
     */
    func makeSearchWords(in words: [String], count: UInt? = nil) -> [String] {
        var results = [String]()
        for word in words {
            results += makeSearchWords(word)
        }
        results = results.shuffled()
        if let count = count, results.count < count {
            return results
        }
        var index = results.count - 1
        if let count = count {
            index = Int(count) - 1
        }
        return Array(results[...index])
    }
    /**
     문자열에서 검색어를 생성한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameters:
        - word: 단어
     */
    func makeSearchWords(_ word: String) -> [String] {
        // 분할할 단어가 있는지 확인한다
        guard word.contains("/") else {
            return [word]
        }
        var searchWords = [String]()
        // " "을 기준으로 문자열을 나누어 배열을 생성
        var components = word.components(separatedBy: " ")
        // 생성한 배열에서 "/"가 포함된 원소를 다시 "/"을 기준으로 나누어 배열을 생성한다
        let dividedWords = components.filter {
            $0.contains("/") }.flatMap { $0.components(separatedBy: "/")
        }
        // 대체할 원소("/"가 포함된 문자열)의 인덱스를 찾는다
        let firstIndex = components.firstIndex {
            $0.contains("/")
        }
        if let index = firstIndex {
            // 나눠진 단어들을 대체할 인덱스에 할당하여 검색어를 생성한다
            for word in dividedWords {
                components[index] = word
                searchWords.append(components.joined(separator: " "))
            }
        }
        return (searchWords.isEmpty) ? [word] : searchWords
    }

    /**
     MyGoodsData의 title에서 HTML을 제거한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameters:
        - title: HTML을 제거할 문자열
        - isReplacing: 개행을 반영할지 여부
     */
    func makeCleanTitle(_ title: String, isReplacing: Bool) -> String {
        return (isReplacing) ?
            removeHTML(from: replaceNewLine(from: title)) : removeHTML(from: title)
    }
}

// MARK: - WordType
extension Algorithm {
    /**
     문자열에 동물(강아지, 고양이) 단어가 포함되었는지 확인한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameters:
        - word: 검사할 단어
     */
    func petIncluded(in word: String) -> Bool {
        if word.contains(Pet.cat.rawValue) || word.contains(Pet.dog.rawValue) {
            return true
        }
        return false
    }
    /**
     문자열 리스트에 동물(강아지, 고양이) 단어를 결합시킨다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameters:
        - pet: 강아지/고양이
        - words: 결합시킬 단어 리스트
     */
    func combinePet(_ pet: Pet, and words: [String]) -> [String] {
        var result = [String]()
        for word in words {
            result.append(combinePet(pet, and: word))
        }
        return result
    }
    /**
     문자열에 동물(강아지, 고양이) 단어를 결합시킨다.
     
     검색어 생성에 사용한다("강아지" + "사료" = "강아지 사료").
     - Author: [최영준](https://github.com/0jun0815)
     - Parameters:
        - pet: 강아지/고양이
        - word: 결합시킬 단어
     */
    func combinePet(_ pet: Pet, and word: String) -> String {
        return "\(pet.rawValue) " + word
    }
    /**
     문자열 리스트에서 동물(강아지, 고양이) 단어를 제거한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameters:
        - words: 검사할 단어 리스트
     */
    func removePet(from words: [String]) -> [String] {
        var result = [String]()
        for word in words {
            result.append(removePet(from: word))
        }
        return result
    }
    /**
     문자열에서 동물(강아지, 고양이) 단어를 제거한다.
     
     상품 정보에 검색어 저장시 사용한다("강아지 사료" = "사료").
     - Author: [최영준](https://github.com/0jun0815)
     - Parameters:
        - word: 검사할 단어
     */
    func removePet(from word: String) -> String {
        guard petIncluded(in: word) else {
            return word
        }
        var result = word.replacingOccurrences(of: " ", with: "")
        for pet in Pet.allCases {
            result = result.replacingOccurrences(of: pet.rawValue, with: "")
        }
        return result
    }
    /**
     문자열에서 HTML 태그를 제거한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameters:
        - string: HTML을 제거할 문자열
    */
    func removeHTML(from string: String) -> String {
        return string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
    /**
     문자열에서 HTML 개행 태그를 반영한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameters:
        - string: 개행을 반영할 문자열
     */
    func replaceNewLine(from string: String) -> String {
        return string.replacingOccurrences(of: "<br>", with: "\n")
    }
}

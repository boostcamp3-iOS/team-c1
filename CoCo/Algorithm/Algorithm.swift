//
//  Algorithm.swift
//  CoCo
//
//  Created by 최영준 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

class Algorithm: AlgorithmType {
    // MARK: - Pagination related properties
    private var onceIndex = 0
    private var maximumIndex = 0
    private var startIndex = 0
    private var recommendedSearchWordsQueue = Queue<String>()

    /**
     PetKeywordData에 포함된 상세 카테고리를 추출한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameter petKeyword: 사용자 관심 펫, 키워드 PetKeywordData
     */
    func extractDetailCategories(_ petKeyword: PetKeywordData) -> [String] {
        var result = [String]()
        guard let petString = petKeyword.pet, let pet = Pet(rawValue: petString),
            let keywordsString = petKeyword.keywords else {
                return []
        }
        var keywords = [Keyword]()
        for string in keywordsString {
            if let keyword = Keyword(rawValue: string) {
                keywords.append(keyword)
            }
        }
        for keyword in keywords {

        }
        return []
    }
}

// MARK: - MakeSearchWordsType
extension Algorithm {
    /**
     둘러보기 페이지에서 네이버 쇼핑 검색 서비스 API에 전달할 쿼리를 생성한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameter myGoods: 찜한 상품 + 최근 본 상품 리스트 [MyGoodsData]
     - Parameter words: 최근 검색한 검색어 리스트
     - Parameter petKeyword: 관심 펫, 키워드 데이터: PetKeywordData
     - Parameter count: 받아올 개수, 입력하지 않으면 전체 데이터를 반환한다.
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
     - Parameter words: 최근 검색한 검색어 리스트
     - Parameter petKeyword: 관심 펫, 키워드 데이터: PetKeywordData
     - Parameter count: 받아올 개수, 입력하지 않으면 전체 데이터를 반환한다.
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
     - Parameter words: 단어 리스트
     - Parameter count: 받아올 개수, 기본값은 10
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
     - Parameter word: 단어
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
     - Parameter title: HTML을 제거할 문자열
     - Parameter isReplacing: 개행을 반영할지 여부
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
     - Parameter word: 검사할 단어
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
     - Parameter pet: 강아지/고양이
     - Parameter words: 결합시킬 단어 리스트
     */
    func combinePet(_ pet: String, and words: [String]) -> [String] {
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
     - Parameter pet: 강아지/고양이
     - Parameter word: 결합시킬 단어
     */
    func combinePet(_ pet: String, and word: String) -> String {
        return "\(pet) " + word
    }
    /**
     문자열 리스트에서 동물(강아지, 고양이) 단어를 제거한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameter words: 검사할 단어 리스트
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
     - Parameter word: 검사할 단어
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
     - Parameter string: HTML을 제거할 문자열
     */
    func removeHTML(from string: String) -> String {
        return string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
    /**
     문자열에서 HTML 개행 태그를 반영한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameter string: 개행을 반영할 문자열
     */
    func replaceNewLine(from string: String) -> String {
        return string.replacingOccurrences(of: "<br>", with: "\n")
    }
}

// MARK: - PaginationType
extension Algorithm {
    /**
     페이지네이션 설정 메서드, 검색 또는 상세카테고리 페이지에서 사용한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameter once: 한 번에 호출할 개수
     - Parameter maximum: 최대 개수
     */
    func setPagination(once: Int, maximum: Int) {
        onceIndex = once
        maximumIndex = maximum
        startIndex = onceIndex - 1
    }

    /**
     상품 추천 페이지네이션 설정 메서드, 둘러보기(상품 추천) 페이지에서 사용한다.
     - Author: [최영준](https://github.com/0jun0815)
     - Parameter words: 요청할 단어 리스트, makeRequestSearchWords(with:words:petKeyword:count:) 호출 결과를 전달한다.
     - Parameter once: 한 번에 호출할 개수
     - Parameter maximum: 최대 개수
     */
    func setRecommendedPagination(words: [String], once: Int, maximum: Int) {
        setPagination(once: once, maximum: maximum)
        recommendedSearchWordsQueue.enqueue(words)
    }
    /**
     페이지네이션 실행 메서드, 검색 또는 상세카테고리 페이지에서 사용한다.
     
     willDisplay에서 indexPath.item 또는 indexPath.row 값을 인자로 전달한다.
     completion 핸들러의 상수 값을 활용하여 네트워크 작업을 수행한다.
     
     - Author: [최영준](https://github.com/0jun0815)
     - Parameter index: 확인할 indexPath.item 또는 indexPath.row 값
     - Parameter completion: 완료 핸들러
     - Parameter isSuccess: 페이지네이션 가능한지 여부
     - Parameter startIndex: 네트워크 요청시 시작할 인덱스
     */
    func pagination(index: Int, completion: @escaping (_ isSuccess: Bool, _ startIndex: Int?) -> Void) {
        if index == maximumIndex - 1 {
            completion(false, nil)
            return
        } else if index != 0, index % startIndex == 0 {
            completion(true, startIndex + 1)
            startIndex += onceIndex
            return
        }
        completion(false, nil)
    }

    /**
     상품추천 페이지네이션 실행 메서드, 둘러보기(상품 추천) 페이지에서 사용한다.
     
     willDisplay에서 indexPath.item 또는 indexPath.row 값을 인자로 전달한다.
     completion 핸들러의 상수 값을 활용하여 네트워크 작업을 수행한다.
     
     - Author: [최영준](https://github.com/0jun0815)
     - Parameter index: 확인할 indexPath.item 또는 indexPath.row 값
     - Parameter completion: 완료 핸들러
     - Parameter isSuccess: 페이지네이션 가능한지 여부
     - Parameter startIndex: 네트워크 요청시 시작할 인덱스
     - Parameter words: 네트워크 호출에 전달할 쿼리, Pet.rawValue를 붙여서 전달한다.
     */
    func recommendedPagination(index: Int, completion: @escaping (_ isSuccess: Bool, _ startIndex: Int?, _ words: String?) -> Void) {
        pagination(index: index) { (isSuccess, startIndex) in
            if isSuccess, let words = self.recommendedSearchWordsQueue.dequeue() {
                completion(isSuccess, startIndex, words)
                self.recommendedSearchWordsQueue.enqueue(words)
                return
            }
            return completion(isSuccess, startIndex, nil)
        }
    }
}

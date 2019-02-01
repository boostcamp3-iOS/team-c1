//
//  AlgorithmManager.swift
//  CoCo
//
//  Created by 최영준 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

private let defaultCount = 10

class AlgorithmManager: Algorithm {
    // MARK: - Properties
    var categories: [Category] { return getAllCategories() }

    // MARK: - Private properties
    private(set) var pet: PetType
    private(set) var keywords = [Keyword]()
    private(set) var recentSearchWords = Queue<String>()
    private(set) var recentProducts = Queue<MyGoodsData>()
    private(set) var favoriteProducts = Queue<MyGoodsData>()

    // MARK: - Initializer
    required init(pet: PetType, keywords: [KeywordType]) {
        self.pet = pet
        addKeywords(keywords)
    }

    // MARK: - Change PetType
    /// 사용자 설정 페이지에서 애완동물 변경시 호출한다
    func changePet(_ type: PetType) {
        guard self.pet != type else { return }
        pet = type
        var newKeywords = [Keyword]()
        // pet 변경에 따라 keyword도 수정된다
        for keyword in keywords {
            newKeywords.append(Keyword(keyword.type, pet: pet))
        }
    }

    // MARK: - Keyword add & remove
    /// 사용자 설정 페이지에서 키워드 추가시 호출한다
    func addKeywords(_ types: [KeywordType]) {
        for type in types {
            addKeyword(type)
        }
    }

    /// 사용자 설정 페이지에서 키워드 추가시 호출한다
    func addKeyword(_ type: KeywordType) {
        let keyword = Keyword(type, pet: pet)
        keywords.append(keyword)
    }

    func removeAllKeywords() {
        keywords.removeAll()
    }

    /// 사용자 설정 페이지에서 키워드 제거시 호출한다
    func removeKeyword(_ type: KeywordType) -> Keyword? {
        let firstIndex = keywords.firstIndex { $0.type == type }
        guard let index = firstIndex else { return nil }
        return keywords.remove(at: index)
    }

    // MARK: - Get all categories
    /// 둘러보기 페이지에서 모든 카테고리 요청시 호출한다
    func getAllCategories() -> [Category] {
        var categories = [Category]()
        for type in CategoryType.allCases {
            categories.append(Category(type, pet: pet))
        }
        return categories
    }

    // MARK: - Queue related methods
    /// 검색 페이지에서 최근 검색어 저장시 호출한다
    func addRecentSearchWords(_ searchWord: [String]) {
        recentSearchWords.enqueue(searchWord)
    }

    /// 둘러보기 페이지, 검색 페이지에서 최근 본 상품 저장시 호출한다
    func addRecentProducts(_ store: [MyGoodsData]) {
        recentProducts.enqueue(store)
    }

    /// 웹뷰에서 찜한 상품 저장시 호출한다
    func addFavoriteProducts(_ store: [MyGoodsData]) {
        favoriteProducts.enqueue(store)
    }

    /// 사용자 설정 페이지에서 초기화 작업시 호출한다
    func removeAllRecentSearchWords() {
        recentSearchWords.clear()
    }

    /// 사용자 설정 페이지에서 초기화 작업시 호출한다
    func removeAllRecentProducts() {
        recentProducts.clear()
    }

    /// 사용자 설정 페이지에서 초기화 작업시 호출한다
    func removeAllFavoriteProducts() {
        favoriteProducts.clear()
    }

    // MARK: - Recommend products and search words
    /// 둘러보기 페이지에서 상품 추천 관련 검색어 필요시 호출한다
    func recommendProducts(count: Int = defaultCount) -> [String] {
        var products = Set<String>()
        let favoriteCount = Int(Double(count) * 0.6)
        // 찜한 상품에서 검색어를 추출한다
        if !favoriteProducts.isEmpty {
            for product in favoriteProducts.latestData {
                if products.count >= favoriteCount { break }
                products.insert(product.searchWord ?? "")
            }
        }
        // 최근 본 상품에서 검색어를 추출한다
        if products.count < favoriteCount, !recentProducts.isEmpty {
            for product in recentProducts.latestData {
                if products.count >= favoriteCount { break }
                products.insert(product.searchWord ?? "")
            }
        }
        // 키워드-카테고리-상세카테고리에서 검색어를 랜덤으로 가져온다
        // 현재 필요한 검색어 개수는 count - products.count
        // but, products에 포함된 검색어와 searchWords에 포함된 검색어간 중복 가능성이 있음
        // 중복 가능성은 최대 products.count이므로
        // count - products.count + products.count = count 호출
        let searchWords = recommendSearchWords(count: count)
        for word in searchWords {
            if products.count >= count { break }
            products.insert(word)
        }
        // 합쳐진 검색어를 섞어서 반환한다
        return Array(products).shuffled()
    }

    /// 검색 페이지에서 추천 검색어를 받아온다
    func recommendSearchWords(count: Int = defaultCount) -> [String] {
        var searchWords = [String]()
        // 키워드-카테고리-상세 카테고리에서 검색어를 생성한다
        for keyword in keywords {
            for category in keyword.categories {
                searchWords += category.getSearchWords(with: false)
            }
        }
        // 검색어를 임의로 섞은 후 반환한다
        searchWords = searchWords.shuffled()
        if searchWords.count < count {
            return searchWords
        }
        let index = count - 1
        return Array(searchWords[...index])
    }
}

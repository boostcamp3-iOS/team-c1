//
//  SearchServiceClass.swift
//  CoCo
//
//  Created by 이호찬 on 01/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
import CoreData

/*
1. fetchRecentSearchWord() -> [String]
2. insert(recentSearchWord: String) -> Void >>>>>>>>>>>
3. getSearchData(search: String, count: Int, display: Int, sort: SortOption) >>>>>>>>>>>
4. fetchRecommandSearchWord() -> [String]
5. pagination(Index: Int) -> Int
 */

// 코어 데이터에 저장할때는 강아지 고양이 뺌
// 검색할때는 검사해서 붙여줌

class SearchService {
    private let searchCoreDataManager: SearchWordCoreDataManagerType
    private let petKeywordCoreDataManager: PetKeywordCoreDataManagerType
    private let networkManager: NetworkManagerType
    private let algorithmManager: Algorithm

    private(set) var recentSearched: String?
    private(set) var keyword = ["옷", "침대", "샤시미", "방석", "수제 간식", "사료", "간식", "후드", "통조림"]
    private(set) var colorChips = [UIColor(red: 1.0, green: 189.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0), UIColor(red: 186.0 / 255.0, green: 166.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0), UIColor(red: 250.0 / 255.0, green: 165.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0), UIColor(red: 166.0 / 255.0, green: 183.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)]

    var dataLists = [MyGoodsData]()
    var sortOption: SortOption = .similar
    var itemStart = 1
    var pet: Pet = .dog

    init(serachCoreData: SearchWordCoreDataManagerType, petCoreData: PetKeywordCoreDataManagerType, network: NetworkManagerType, algorithm: Algorithm) {
        searchCoreDataManager = serachCoreData
        petKeywordCoreDataManager = petCoreData
        networkManager = network
        algorithmManager = algorithm
    }

    func getShoppingData(search: String, completion: @escaping (_ isSuccess: Bool, NetworkErrors?) -> Void) {
        let word = algorithmManager.removePet(from: search)
        let searchWord = algorithmManager.combinePet(pet, and: word)
        print("in service \(searchWord)")
        let params = ShoppingParams(search: searchWord, count: 20, start: itemStart, sort: sortOption)

        DispatchQueue.global().async {
            self.networkManager.getAPIData(params, completion: { data in
                if data.items.isEmpty {
                    completion(false, NetworkErrors.noData)
                    return
                }
                if self.itemStart == 1 {
                    self.dataLists.removeAll()
                }
                for goods in data.items {
                    let title = self.algorithmManager.removeHTML(from: goods.title)
                    self.dataLists.append(MyGoodsData(pet: Pet.dog.rawValue, title: title, link: goods.link, image: goods.image, isFavorite: false, isLatest: true, price: goods.lprice, productID: goods.productId, searchWord: search, shoppingmall: goods.mallName))
                }
                completion(true, nil)
            }) {_ in completion(false, NetworkErrors.badInput)}
        }
    }
    func fetchRecommandSearchWord(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        let queue = DispatchQueue.main
        var recommandWords: PetKeywordData?
        var recentSearchWords = [String]()
        fetchRecommandWords(queue, group: group) { words in
            recommandWords = PetKeywordData(pet: self.pet.rawValue, keywords: words)
        }
        fetchRecentSearchWords(queue, group: group) { words in
            recentSearchWords = words
        }

        group.notify(queue: DispatchQueue.main) {
            guard let recommandWords = recommandWords else {
                return
            }
            self.keyword = self.algorithmManager.makeRecommendedSearchWords(with: recentSearchWords, petKeyword: recommandWords, count: 20)
            completion()
        }
    }
    // 추천검색 키워드
    private func fetchRecommandWords(_ queue: DispatchQueue, group: DispatchGroup, completion: @escaping ([String]) -> Void) {
        queue.async(group: group) {
            do {
                if let keyword = try self.petKeywordCoreDataManager.fetchOnlyKeyword(pet: self.pet.rawValue) {
                    completion(keyword)
                }
            } catch let err {
                print(err)
            }
        }
    }
    // 최근검색 키워드
    private func fetchRecentSearchWords(_ queue: DispatchQueue, group: DispatchGroup, completion: @escaping ([String]) -> Void) {
        queue.async(group: group) {
            do {
                if let searchWord = try self.searchCoreDataManager.fetchOnlySearchWord(pet: self.pet.rawValue) {
                    completion(searchWord)
                }
            } catch let err {
                print(err)
            }
        }
    }
    func insert(recentSearchWord: String) {
        // "강아지", "고양이" 키워드를 제거하고 코어데이터에 저장
        let word = algorithmManager.removePet(from: recentSearchWord)
        self.recentSearched = word
        let searchWord = SearchWordData(pet: pet.rawValue, searchWord: word)
        do {
            _ = try self.searchCoreDataManager.insert(searchWord)
        } catch let err {
            print(err)
        }
    }
}

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
    let pet = "고양이"
    private let searchCoreDataManager: SearchWordCoreDataManagerType
    private let petKeywordCoreDataManager: PetKeywordCoreDataManagerType
    private let networkManager: NetworkManagerType
    private let algorithmManager: Algorithm

    var dataLists = [MyGoodsData]()
    var recentSearched: String?
    var sortOption: SortOption = .similar
    var itemStart = 1
    var recentSearchWords = [String]()
    var recommandSearchWords = [String]()
    var keyword = ["옷", "침대", "샤시미", "방석", "수제 간식", "사료", "간식", "후드", "통조림"]
    var colorChips = [UIColor(red: 1.0, green: 189.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0), UIColor(red: 186.0 / 255.0, green: 166.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0), UIColor(red: 250.0 / 255.0, green: 165.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0), UIColor(red: 166.0 / 255.0, green: 183.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)]

    init(serachCoreData: SearchWordCoreDataManagerType, petCoreData: PetKeywordCoreDataManagerType, network: NetworkManagerType, algorithm: Algorithm) {
        searchCoreDataManager = serachCoreData
        petKeywordCoreDataManager = petCoreData
        networkManager = network
        algorithmManager = algorithm
    }

    func getShoppingData(search: String, completion: @escaping (Bool, Error?) -> Void) {
        let word = algorithmManager.removePet(from: search)
        let searchWord = algorithmManager.combinePet(pet, and: word)
        print(searchWord)
        let params = ShoppingParams(search: searchWord, count: 20, start: itemStart, sort: sortOption)

        DispatchQueue.global().async {
            self.networkManager.getAPIData(params, completion: { data in
                for goods in data.items {
                    self.dataLists.append(MyGoodsData(pet: self.pet, title: goods.title, link: goods.link, image: goods.image, isFavorite: false, isLatest: true, price: goods.lprice, productID: goods.productId, searchWord: search, shoppingmall: goods.mallName))
                }
                completion(true, nil)
            }) {err in completion(false, err)}
        }
    }

    func checkSearchWord(search: String) {

    }

    func fetchRecommandSearchWord(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        var keyword: Keyword?
        // 최근검색어 가져옴
        queue.async(group: group) {
            do {
                let searchWord = try self.searchCoreDataManager.fetchOnlySearchWord(pet: self.pet) ?? []
                self.recentSearchWords = self.algorithmManager.removePet(from: searchWord)
                group.leave()
            } catch let err {
                print(err)
            }
        }
        // 추천검색 키워드 가져옴
        keyword = fetchRecommandword(queue, group: group)

       // 최근 본 상품, 찜한 데이터 가져오기
        // 내일 MyGoodsCoreData 수정 후 다시 하기
//        group.notify(queue: DispatchQueue.main) {
//            self.recommandSearchWords = self.algorithmManager.makeRequestSearchWords(favorite: <#T##[MyGoodsData]#>, recent: <#T##[MyGoodsData]#>, words: keyword)
//            completion()
//        }
    }

    // 추천검색 키워드
    private func fetchRecommandword(_ queue: DispatchQueue, group: DispatchGroup) -> Keyword? {
        var result: Keyword?
        queue.async(group: group) {
        }
        return result!
    }

    func insert(recentSearchWord: String) {
        // "강아지", "고양이" 키워드를 제거하고 코어데이터에 저장
        let word = algorithmManager.removePet(from: recentSearchWord)
        self.recentSearched = word
        let searchWord = SearchWordData(pet: pet, searchWord: word)
        do {
            _ = try self.searchCoreDataManager.insert(searchWord)
        } catch let err {
            print(err)
        }
    }

    func fetchRecentSearchWord() -> [String]? {
        var fetchSearchWord: [String]?
        do {
            fetchSearchWord =  try searchCoreDataManager.fetchOnlySearchWord(pet: pet)
        } catch let error {
            print(error)
        }
        return fetchSearchWord
    }

    @discardableResult func insert(recenteSearchWord: String) -> Bool {
        var result = false
        var searchWordData = SearchWordData()
        searchWordData.date = searchWordData.createDate()
        searchWordData.searchWord = recenteSearchWord
        do {
            result = try searchCoreDataManager.insert(searchWordData)
        } catch let error {
            print(error)
        }
        return result
    }

}

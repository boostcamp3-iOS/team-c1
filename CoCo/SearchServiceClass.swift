//
//  SearchServiceClass.swift
//  CoCo
//
//  Created by 이호찬 on 01/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

/* 1. fetchRecentSearchWord() -> [String]
2. insert(recentSearchWord: String) -> Void
3. getSearchData(search: String, count: Int, display: Int, sort: SortOption) -> [ShoppingItem]
4. fetchRecommandSearchWord() -> [String]
5. pagination(Index: Int) -> Int
 */

class SearchService {
    let searchCoreDataManager: SearchWordCoreDataManagerType
    let petKeywordCoreDataManager: PetKeywordCoreDataManagerType
    let networkManager: NetworkManagerType
    let algorithmManager: Algorithm?

    init(serachCoreData: SearchWordCoreDataManagerType,
         petCoreData: PetKeywordCoreDataManagerType,
         network: NetworkManagerType, algorithm: Algorithm? = nil) {
        self.searchCoreDataManager = serachCoreData
        self.petKeywordCoreDataManager = petCoreData
        self.networkManager = network
        self.algorithmManager = algorithm
    }

    func fetchRecentSearchWord() -> [String]? {
        var fetchSearchWord: [String]?
        do {
            fetchSearchWord =  try searchCoreDataManager.fetchOnlySearchWord(pet: "")
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

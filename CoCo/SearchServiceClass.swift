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
    let searchCoreDataManager: SearchKeywordCoreDataManagerType
    let petKeywordCoreDataManager: PetKeywordCoreDataManagerType
    let networkManager: NetworkManagerType
    let algorithmManager: Algorithm?
    
    init(serachCoreData: SearchKeywordCoreDataManagerType,
         petCoreData: PetKeywordCoreDataManagerType,
         network: NetworkManagerType, algorithm: Algorithm? = nil) {
        self.searchCoreDataManager = serachCoreData
        self.petKeywordCoreDataManager = petCoreData
        self.networkManager = network
        self.algorithmManager = algorithm
    }
    
    func fetchRecentSearchWord() -> [CoreDataEntity] {
        var fetchSearchWord = [CoreDataEntity]()
        let sort = NSSortDescriptor(key: #keyPath(SearchKeyword.date), ascending: true)
        do {
            fetchSearchWord =  try searchCoreDataManager.fetch(SearchKeywordData.self, sortBy: nil, predicate: nil)!
        } catch let error {
            
        }
        return fetchSearchWord
    }
    
    
}

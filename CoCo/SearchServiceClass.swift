//
//  SearchServiceClass.swift
//  CoCo
//
//  Created by 이호찬 on 01/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
import CoreData

/* 1. fetchRecentSearchWord() -> [String]
2. insert(recentSearchWord: String) -> Void
3. getSearchData(search: String, count: Int, display: Int, sort: SortOption) -> [ShoppingItem]
4. fetchRecommandSearchWord() -> [String]
5. pagination(Index: Int) -> Int
 */

class SearchService {
    let searchCoreDataManager: SearchWordCoreDataManagerType?
    let petKeywordCoreDataManager: PetKeywordCoreDataManagerType?
    let networkManager: NetworkManagerType
    let algorithmManager: Algorithm?

    var dataList = [MyGoodsData]()
    var sortOption: SortOption = .similar
    var keyword = ["강아지 옷", "강아지 침대", "강아지 방석", "강아지 사료", "강아지 간식"]
    var colorChips = [UIColor(red: 1.0, green: 189.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0), UIColor(red: 186.0 / 255.0, green: 166.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0), UIColor(red: 250.0 / 255.0, green: 165.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0), UIColor(red: 166.0 / 255.0, green: 183.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)]

    init(serachCoreData: SearchWordCoreDataManagerType? = nil,
         petCoreData: PetKeywordCoreDataManagerType? = nil,
         network: NetworkManagerType, algorithm: Algorithm? = nil) {
        self.searchCoreDataManager = serachCoreData
        self.petKeywordCoreDataManager = petCoreData
        self.networkManager = network
        self.algorithmManager = algorithm
    }

    func getShoppingData(search: String, completion: @escaping (Bool, Error?) -> Void) {
        let params = ShoppingParams(search: search, count: 10, start: 1, sort: sortOption)

        DispatchQueue.global().async {
            self.networkManager.getAPIData(params, completion: { data in
                for i in data.items {
                    self.dataList.append(MyGoodsData(pet: "강아지", title: i.title, link: i.link, image: i.image, isFavorite: false, isLatest: true, price: i.hprice, productId: i.productId, searchWord: search, shoppingmall: i.mallName))
                }
//                print(self.dataList)
                completion(true, nil) }) {err in
                completion(false, err)
            }
        }
    }

//    func fetchRecentSearchWord() -> [String]? {
//        var fetchSearchWord: [String]?
//        do {
//            fetchSearchWord =  try searchCoreDataManager.fetchOnlySearchWord(pet: "")
//        } catch let error {
//            print(error)
//        }
//        return fetchSearchWord
//    }
//
//    @discardableResult func insert(recenteSearchWord: String) -> Bool {
//        var result = false
//        var searchWordData = SearchWordData()
//        searchWordData.date = searchWordData.createDate()
//        searchWordData.searchWord = recenteSearchWord
//        do {
//            result = try searchCoreDataManager.insert(searchWordData)
//        } catch let error {
//            print(error)
//        }
//        return result
//    }

}

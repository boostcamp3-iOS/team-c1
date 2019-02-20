//
//  DiscoverDetailService.swift
//  CoCo
//
//  Created by 이호찬 on 16/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

/*
 상품 카테고리 눌렀을 경우 데이터 받아오기
 데이터 받아서 인덱스에 저장
 소트 형식 저장
 상세 카테고리 정보 가져오기
 
 */

class DiscoverDetailService {
    private let searchCoreDataManager: SearchWordCoreDataManagerType
    private let petKeywordCoreDataManager: PetKeywordCoreDataManagerType
    private let networkManager: NetworkManagerType
    private let algorithmManager: Algorithm

    private(set) var recentSearched: String?
    var dataLists = [MyGoodsData]()
    var sortOption: SortOption = .similar
    var pet: Pet = .dog

    init(serachCoreData: SearchWordCoreDataManagerType, petCoreData: PetKeywordCoreDataManagerType, network: NetworkManagerType, algorithm: Algorithm) {
        searchCoreDataManager = serachCoreData
        petKeywordCoreDataManager = petCoreData
        networkManager = network
        algorithmManager = algorithm
    }

    func setPet(pet: Pet) {
        self.pet = pet
    }

    func getShoppingData(start: Int, search: String, completion: @escaping (_ isSuccess: Bool, NetworkErrors?) -> Void) {
        var itemStart = start
        if recentSearched != search {
            itemStart = 1
        }
        recentSearched = search
        let searchWord = algorithmManager.combinePet(pet, and: search)
        let params = ShoppingParams(search: searchWord, count: 20, start: itemStart, sort: sortOption)

        DispatchQueue.global().async {
            self.networkManager.getAPIData(params, completion: { [weak self] data in
                guard let self = self else {
                    return
                }
                if data.items.isEmpty {
                    completion(false, NetworkErrors.noData)
                    return
                }
                if itemStart == 1 {
                    self.dataLists.removeAll()
                }
                for goods in data.items {
                    let title = self.algorithmManager.makeCleanTitle(goods.title, isReplacing: true)
                    var mallName = goods.mallName
                    if goods.mallName == "네이버" {
                        mallName = "네이버쇼핑"
                    }
                    let price = self.algorithmManager.addComma(to: goods.lprice)
                    self.dataLists.append(MyGoodsData(pet: Pet.dog.rawValue, title: title, link: goods.link, image: goods.image, isFavorite: false, isLatest: true, price: price, productID: goods.productId, searchWord: search, shoppingmall: mallName))
                }
                completion(true, nil)
            }) {_ in completion(false, NetworkErrors.badInput)}
        }
    }
}

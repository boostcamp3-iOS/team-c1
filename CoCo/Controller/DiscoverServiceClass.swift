//
//  DiscoverService.swift
//  CoCo
//
//  Created by 강준영 on 13/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

/*
 1. 추천상품 보여주기
    (1) 코어데이터에서 최근본 상품 가져오기
    (2) 코어데이터에서 즐겨찾기 항목 가져오기
    (3) 최근검색 가져오기
    (4) 알고리즘으로 최근검색 키워드 섞기
    (5) 네트워트에서 섞은 검색어 Request
    (6) 네트워크에서 추천 데이터 가져오기
    (7) 알고리즘에서 가져온 쇼핑목록들 섞고 배열에 넣기
 */
class DiscoverServiceClass {
    let pet = Pet.cat
    let networkManagerType: NetworkManagerType?
    let algorithmManagerType: AlgorithmType?
    let searchWordDoreDataManagerType: SearchWordCoreDataManagerType?
    let myGoodsCoreDataType: MyGoodsCoreDataManagerType?

    var recommandGoods = [String]()
    var favorites: [MyGoodsData]?
    var latests: [MyGoodsData]?
    var searches: [String]?

    init(networkManagerType: NetworkManagerType? = nil, algorithmManagerType: AlgorithmType? = nil, searchWordDoreDataManagerType: SearchWordCoreDataManagerType? = nil, myGoodsCoreDataType: MyGoodsCoreDataManagerType? = nil) {
        self.networkManagerType = networkManagerType
        self.algorithmManagerType = algorithmManagerType
        self.searchWordDoreDataManagerType = searchWordDoreDataManagerType
        self.myGoodsCoreDataType = myGoodsCoreDataType
    }

    //(1) 코어데이터에서 최근검색 가져오기
    func latestGoods() -> [MyGoodsData]? {
        guard let myGoodsCoreDataType = self.myGoodsCoreDataType else {
            return nil
        }
        do {
            let result = try myGoodsCoreDataType.fetchLatestGoods(pet: pet, isLatest: true, ascending: false)
            return result
        } catch let error {
            print(error)
        }
        return nil
    }

    //(2) 코어데이터에서 즐겨찾기 항목 가져오기
    func searchWord() -> [String]? {
        guard let searchWordDoreDataManagerType = self.searchWordDoreDataManagerType else {
            return nil
        }
        guard let result = try? searchWordDoreDataManagerType.fetchOnlySearchWord(pet: self.pet) else {
            return nil
        }
        return result
    }

    //(3) 최근검색 가져오기
    func favoriteGoods() -> [MyGoodsData]? {
        guard let  myGoodsCoreDataType = myGoodsCoreDataType else {
            return nil
        }
        do {
            let result = try myGoodsCoreDataType.fetchFavoriteGoods(pet: pet)
            return result
        } catch let error {
            print(error)
        }

        return nil
    }

    // (4) 알고리즘으로 최근검색 키워드 섞기
    func mixedWord() -> [String] {
        favorites = favoriteGoods()
        latests = latestGoods()
        searches = searchWord()
        guard let favorite = favorites, let latest = latests, let search = searches else {
            return []
        }
        guard let algorithmManagerType = algorithmManagerType else {
            return []
        }
        let result = algorithmManagerType.makeRequestSearchWords(favorite: favorite, recent: latest, words: search, count: 10)
        return result
    }

    // 5) 네트워트에서 섞은 검색어 Request
    func request() {
    }

    //(6) 네트워크에서 추천 데이터 가져오기
    func dispatch() {

    }

    // (7) 알고리즘에서 가져온 쇼핑목록들 섞고 배열에 넣기
    func mixedGoods() {

    }

}

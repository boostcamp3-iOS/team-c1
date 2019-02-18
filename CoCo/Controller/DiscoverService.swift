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
 (1) 코어데이터에서 최근본 상품, 찜상품 가져오기
 (2) 코어데이터에서 최근검색 가져오기
 (3) 펫키워드 가져오기
 (4) 알고리즘으로 최근검색 키워드 섞기
 (5) 네트워트에서 섞은 검색어 Request
 (6) 네트워크에서 추천 데이터 가져오기
 (7) 알고리즘에서 가져온 쇼핑목록들 섞고 배열에 넣기
 */
class DiscoverService {
    // MARK: - Propertise
    private let networkManagerType: NetworkManagerType?
    private let algorithmManagerType: AlgorithmType?
    private let petKeywordCoreDataManagerType: PetKeywordCoreDataManagerType?
    private let searchWordDoreDataManagerType: SearchWordCoreDataManagerType?
    private let myGoodsCoreDataType: MyGoodsCoreDataManagerType?
    private var pet = Pet.cat

    private var recommandGoods = [String]()
    private var myGoods = [MyGoodsData]()
    private var searches = [String]()
    private var mixedletSearches = [String]()
    private var keyword: PetKeywordData?
    var fetchedMyGoods = [MyGoodsData]()
    var pageNumber = 1

    // MARK: - Initialize
    init(networkManagerType: NetworkManagerType? = nil, algorithmManagerType: AlgorithmType? = nil, searchWordDoreDataManagerType: SearchWordCoreDataManagerType? = nil, myGoodsCoreDataType: MyGoodsCoreDataManagerType? = nil, petKeywordCoreDataManagerType: PetKeywordCoreDataManagerType? = nil) {
        self.networkManagerType = networkManagerType
        self.algorithmManagerType = algorithmManagerType
        self.searchWordDoreDataManagerType = searchWordDoreDataManagerType
        self.myGoodsCoreDataType = myGoodsCoreDataType
        self.petKeywordCoreDataManagerType = petKeywordCoreDataManagerType
    }

    //(1) 코어데이터에서 최근본 상품, 찜상품 가져오기
    @discardableResult func fetchMyGoods() -> [MyGoodsData] {
        guard let myGoodsCoreDataType = self.myGoodsCoreDataType else {
            return []
        }
        do {
            guard let result = try myGoodsCoreDataType.fetchObjects(pet: pet.rawValue) as? [MyGoodsData] else {
                return []
            }
            myGoods = result
            return result
        } catch let error {
            print(error)
        }
        return []
    }

    // (2) 코어데이터에서 최근검색 가져오기
    @discardableResult func fetchSearchWord() -> [String] {
        guard let searchWordDoreDataManagerType = self.searchWordDoreDataManagerType else {
            return []
        }
        do {
            guard let result = try searchWordDoreDataManagerType.fetchOnlySearchWord(pet: self.pet.rawValue) else {
                return []
            }
            searches = result
            return result
        } catch let error {
            print(error)
            return []
        }
    }

    // (3) 펫키워드 가져오기
    @discardableResult func fetchPetKeywords() -> PetKeywordData? {
        guard let petKeywordCoreDataManagerType =  self.petKeywordCoreDataManagerType else {
            return nil
        }
        do {

            guard let keywords = try petKeywordCoreDataManagerType.fetchObjects(pet: self.pet.rawValue) as? [PetKeywordData] else {
                return nil
            }
            let result = keywords.first
            keyword = result
            return result
        } catch let error as NSError {
            return nil
            print(error)
        }
    }

    // (4) 알고리즘으로 최근검색 키워드 섞기
    @discardableResult func mixedWord() -> [String] {
        guard let keyword = keyword else {
            return []
        }
        guard let algorithmManagerType = algorithmManagerType else {
            return []
        }
        let result = algorithmManagerType.makeRequestSearchWords(with: [], words: [], petKeyword: keyword, count: 4)
        let mixedResult = result
        recommandGoods = mixedResult
        mixedletSearches = algorithmManagerType.combinePet(self.pet, and: recommandGoods)
        return mixedResult
    }

    // 5) 네트워트에서 섞은 검색어 Request
    func request(completion: @escaping (Bool, Error?) -> Void) {
        guard let search = mixedletSearches.popLast() else {
            return
        }
        let param = ShoppingParams(search: search, count: 20, start: 1, sort: .similar)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.networkManagerType?.getAPIData(param, completion: { (datas) in
                    if datas.items.isEmpty {
                        completion(false, nil)
                    }
                    for data in datas.items {
                        print(data)
                        guard let shopItemToMyGoods = self.shopItemToMyGoods(item: data, searchWord: search) else {
                            return
                        }
                        self.fetchedMyGoods.append(shopItemToMyGoods)
                        print(self.fetchedMyGoods)
                    }
                completion(true, nil)
            }, errorHandler: { (error) in
                completion(false, error)
                print(error)
            })
        }
    }

    func chagePet() {
        if pet == Pet.dog {
            pet = Pet.cat
        } else {
            pet = Pet.dog
        }
    }

    func setPagenation() {
        guard let algorithmManagerType = algorithmManagerType else {
            return
        }
        algorithmManagerType.setRecommendedPagination(words: recommandGoods, once: 20, maximum: 200)
    }

    func recommandPagenation(indexPathRow: Int, completion: @escaping (Bool, Error?) -> Void) {
        guard let algorithmManagerType = algorithmManagerType else {
            return
        }
      algorithmManagerType.recommendedPagination(index: indexPathRow) {
            (isSuccess, startIndex, search) in
            if isSuccess, let startIndex = startIndex, let search = search {
                self.request(completion: { (isSuccess, error) in
                    if let error = error {
                        completion(false, error)
                    }
                    if isSuccess {
                        completion(true, nil)
                    }
                })
            }
        }
    }

    private func shopItemToMyGoods(item: ShoppingItem, searchWord: String) -> MyGoodsData? {
        print(item.title)
        guard let algorithmManagerType = algorithmManagerType else {
            return nil
        }
        let title = algorithmManagerType.makeCleanTitle(item.title, isReplacing: true)
        var mallName = item.mallName
        if item.mallName == "네이버" {
            mallName = "네이버쇼핑"
        }
        let price = algorithmManagerType.addComma(to: item.lprice)
        return MyGoodsData(pet: pet.rawValue, title: title, link: item.link, image: item.image, isFavorite: false, isLatest: false, price: price, productID: item.productId, searchWord: searchWord, shoppingmall: mallName)
    }
}

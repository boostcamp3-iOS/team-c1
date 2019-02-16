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
class DiscoverServiceClass {
    // MARK: - Propertise
    private let pet = "고양이"
    private let networkManagerType: NetworkManagerType?
    private let algorithmManagerType: AlgorithmType?
    private let petKeywordCoreDataManagerType: PetKeywordCoreDataManagerType?
    private let searchWordDoreDataManagerType: SearchWordCoreDataManagerType?
    private let myGoodsCoreDataType: MyGoodsCoreDataManagerType?

    private var recommandGoods = [String]()
    private var myGoods = [MyGoodsData]()
    private var searches = [String]()
    private var keyword: PetKeywordData?
    var fetchedMyGoods = [MyGoodsData]()

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
            guard let result = try myGoodsCoreDataType.fetchObjects(pet: pet) as? [MyGoodsData] else {
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
            guard let result = try searchWordDoreDataManagerType.fetchOnlySearchWord(pet: self.pet) else {
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
            guard let keywords = try petKeywordCoreDataManagerType.fetchObjects(pet: pet) as? [PetKeywordData] else {
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
        let result = algorithmManagerType?.makeRequestSearchWords(with: myGoods, words: searches, petKeyword: keyword, count: 10)
        guard let mixedResult = result else {
            return []
        }
        recommandGoods = mixedResult
        return mixedResult
    }

    // 5) 네트워트에서 섞은 검색어 Request
    func request(completion: @escaping (Bool, Error?) -> Void) {
        guard let algorithmManagerType = algorithmManagerType, let pet = Pet(rawValue: self.pet) else {
            return
        }
        let searches = algorithmManagerType.combinePet(pet, and: recommandGoods)
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        for search in searches {
            group.enter()
            let param = ShoppingParams(search: search, count: 20, start: 1, sort: .similar)
            queue.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.networkManagerType?.getAPIData(param, completion: { (datas) in
                    if datas.items.isEmpty {
                        completion(false, nil)
                    }
                    for data in datas.items {
                        self.fetchedMyGoods.append(self.shopItemToMyGoods(item: data, searchWord: search))
                    }
                    group.leave()
                }, errorHandler: { (error) in
                    group.leave()
                    completion(false, error)
                    print(error)
                })
            }
        }
        group.notify(queue: queue) {
            completion(true, nil)
        }
    }

    private func shopItemToMyGoods(item: ShoppingItem, searchWord: String) -> MyGoodsData {
        return MyGoodsData(pet: pet, title: item.title, link: item.link, image: item.image, isFavorite: false, isLatest: false, price: item.lprice, productID: item.productId, searchWord: searchWord, shoppingmall: item.mallName)
    }

    /*func request(recommands: [String], completion: @escaping (Bool, Error?) -> Void) {
        guard let searches = algorithmManagerType?.combinePet(self.pet, and: recommands) else {
            return
        }
        for search in searches {
            let param = ShoppingParams(search: search, count: 10, start: 0, sort: .ascending)
            DispatchQueue.global().async { [weak self] in
                guard let self = self else {
                    return
                }
                self.networkManagerType?.getAPIData(param, completion: { (datas) in
                    for data in datas.items {
                        self.fetchGoodsData.append(MyGoodsData(pet: self.pet, title: data.title, link: data.link, image: data.image, isFavorite: true, isLatest: true, price: data.lprice, productID: data.productId, searchWord: search, shoppingmall: data.mallName))
                        completion(true, nil)
                    }
                }, errorHandler: { (error) in
                    completion(false, error)
                })
            }
        }
    }*/
}

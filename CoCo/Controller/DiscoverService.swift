//
//  DiscoverService.swift
//  CoCo
//
//  Created by 강준영 on 13/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//
import Foundation

class DiscoverService {
    // MARK: - Propertise
    private let networkManagerType: NetworkManagerType?
    private let algorithmManagerType: AlgorithmType?
    private let petKeywordCoreDataManagerType: PetKeywordCoreDataManagerType?
    private let searchWordDoreDataManagerType: SearchWordCoreDataManagerType?
    private let myGoodsCoreDataManagerType: MyGoodsCoreDataManagerType?
    var recommandGoods = [String]()
    var myGoods = [MyGoodsData]()
    var searches = [String]()
    var mixedletSearches = [String]()
    var keyword: PetKeywordData?
    var fetchedMyGoods = [MyGoodsData]()
    var pageNumber = 1
    var pet = Pet.dog

    // MARK: - Initialize
    init(networkManagerType: NetworkManagerType? = nil, algorithmManagerType: AlgorithmType? = nil, searchWordDoreDataManagerType: SearchWordCoreDataManagerType? = nil, myGoodsCoreDataManagerType: MyGoodsCoreDataManagerType? = nil, petKeywordCoreDataManagerType: PetKeywordCoreDataManagerType? = nil) {
        self.networkManagerType = networkManagerType
        self.algorithmManagerType = algorithmManagerType
        self.searchWordDoreDataManagerType = searchWordDoreDataManagerType
        self.myGoodsCoreDataManagerType = myGoodsCoreDataManagerType
        self.petKeywordCoreDataManagerType = petKeywordCoreDataManagerType
    }

    // (1)코어데이터에서 펫정보 가져오기
    func fetchPet(completion: @escaping () -> Void) {
        guard  let petKeywordCoreDataManagerType = petKeywordCoreDataManagerType else {
            return
        }
        petKeywordCoreDataManagerType.fetchOnlyPet { (petValue, _) in
            if petValue == "강아지" {
                PetDefault.shared.pet = .dog
            } else {
                PetDefault.shared.pet = .cat
            }
            completion()
        }
    }

    // (2) 코어데이터에서 최근본 상품, 찜상품 가져오기
    func fetchMyGoods(completion: @escaping () -> Void) {
        guard let myGoodsCoreDataManagerType = self.myGoodsCoreDataManagerType
            else {
                return
        }
        do {
            try myGoodsCoreDataManagerType.fetchObjects(pet: PetDefault.shared.pet.rawValue) {
                [weak self] (coreData, _) in
                guard let self = self else {
                    return
                }
                guard let myGoodsData = coreData as? [MyGoodsData] else {
                    return
                }
                self.myGoods = myGoodsData
                completion()
            }
        } catch let error {
        }
    }

    // (3) 코어데이터에서 최근검색 가져오기
    func fetchSearchWord(completion: @escaping () -> Void) {
        guard let searchWordDoreDataManagerType = self.searchWordDoreDataManagerType else {
            return
        }
        searchWordDoreDataManagerType.fetchOnlySearchWord(pet: PetDefault.shared.pet.rawValue) { [weak self] (searchResult) in
            if let searchResult = searchResult {
                self?.searches = searchResult
            }
            completion()
        }
    }

    // (4) 펫키워드 가져오기
    func fetchPetKeywords(completion: @escaping () -> Void) {
        guard let petKeywordCoreDataManagerType =  self.petKeywordCoreDataManagerType else {
            return
        }
        petKeywordCoreDataManagerType.fetchObjects(pet: PetDefault.shared.pet.rawValue) { [weak self] (coreData, _) in
            guard let keywords = coreData as? [PetKeywordData] else {
                return
            }
            self?.keyword = keywords.first
            completion()
        }
    }

    // (5) 알고리즘으로 최근검색 키워드 섞기
    func mixedWord(completion: @escaping () -> Void) {
        guard let algorithmManagerType = algorithmManagerType else {
            return
        }

        guard let keyword = self.keyword else {
            return
        }
        print("5")
        self.recommandGoods = algorithmManagerType.makeRequestSearchWords(with: self.myGoods, words: self.searches, petKeyword: keyword, count: 10)
        self.mixedletSearches =  algorithmManagerType.combinePet(PetDefault.shared.pet, and: self.recommandGoods)
        completion()
        print(self.mixedletSearches)

    }

    // (6) 네트워트에서 섞은 검색어 Request
    func request(completion: @escaping (Bool, Error?, Int?) -> Void) {
        guard let search = mixedletSearches.popLast() else {
            return
        }
        let param = ShoppingParams(search: search, count: 20, start: 1, sort: .similar)
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                return
            }
            self.networkManagerType?.getAPIData(param, completion: { (datas) in
                if datas.items.isEmpty {
                    completion(false, nil, nil)
                }
                for data in datas.items {
                    guard let shopItemToMyGoods = self.shopItemToMyGoods(item: data, searchWord: search) else {
                        return
                    }
                    self.fetchedMyGoods.append(shopItemToMyGoods)
                }
                completion(true, nil, datas.items.count)
            }, errorHandler: { (error) in
                completion(false, error, nil)
                print(error)
            })
        }
    }

    private func shopItemToMyGoods(item: ShoppingItem, searchWord: String) -> MyGoodsData? {
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

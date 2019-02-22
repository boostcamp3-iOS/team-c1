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
    @discardableResult func fetchPet() {
        guard  let petKeywordCoreDataManagerType = petKeywordCoreDataManagerType else {
            return
        }
        do {
            let pet = try petKeywordCoreDataManagerType.fetchOnlyPet()
            if pet == "강아지" {
                PetDefault.shared.pet = .dog
            } else {
                PetDefault.shared.pet = .cat
            }
        } catch let error {
            print("Fail fetch pet: \(error)")
        }
    }

    // (2) 코어데이터에서 최근본 상품, 찜상품 가져오기
    @discardableResult func fetchMyGoods() -> [MyGoodsData] {
        guard let myGoodsCoreDataManagerType = self.myGoodsCoreDataManagerType else {
            return []
        }

        do {
            guard let result = try myGoodsCoreDataManagerType.fetchObjects(pet: PetDefault.shared.pet.rawValue) as? [MyGoodsData] else {
                return []
            }
            myGoods = result
            return result
        } catch let error {
            print(error)
        }
        return []
    }

    // (3) 코어데이터에서 최근검색 가져오기
    @discardableResult func fetchSearchWord() -> [String] {
        guard let searchWordDoreDataManagerType = self.searchWordDoreDataManagerType else {
            return []
        }
        do {
            guard let result = try searchWordDoreDataManagerType.fetchOnlySearchWord(pet: PetDefault.shared.pet.rawValue) else {
                return []
            }
            searches = result
            return result
        } catch let error {
            print(error)
            return []
        }
    }

    // (4) 펫키워드 가져오기
    @discardableResult func fetchPetKeywords() -> PetKeywordData? {
        guard let petKeywordCoreDataManagerType =  self.petKeywordCoreDataManagerType else {
            return nil
        }
        do {
            guard let keywords = try petKeywordCoreDataManagerType.fetchObjects(pet: PetDefault.shared.pet.rawValue) as? [PetKeywordData] else {
                return nil
            }
            let result = keywords.first
            keyword = result
            return result
        } catch let error as NSError {
            return nil
        }
    }

    // (5) 알고리즘으로 최근검색 키워드 섞기
    @discardableResult func mixedWord() -> [String] {
        guard let keyword = keyword else {
            return []
        }
        guard let algorithmManagerType = algorithmManagerType else {
            return []
        }
        let result = algorithmManagerType.makeRequestSearchWords(with: myGoods, words: searches, petKeyword: keyword, count: 4)
        let mixedResult = result
        recommandGoods = mixedResult
        mixedletSearches = algorithmManagerType.combinePet(PetDefault.shared.pet, and: recommandGoods)
        return mixedResult
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

    func setPet() {
        if PetDefault.shared.pet == .dog {
            self.pet = .dog
        } else {
            self.pet = .cat
        }
    }

    func chagePet() {
        if pet == Pet.dog {
            self.pet = Pet.cat
        } else {
            self.pet = Pet.dog
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
                self.request(completion: { (isSuccess, error, _) in
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

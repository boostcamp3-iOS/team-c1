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

    // MARK: - Methodes
    func fetchData(completion:@escaping (Bool, Error?) -> Void) {
        guard let petKeywordCoreDataManagerType = petKeywordCoreDataManagerType,
            let myGoodsCoreDataManagerType = myGoodsCoreDataManagerType,
            let searchWordDoreDataManagerType = searchWordDoreDataManagerType,
            let algorithmManagerType = algorithmManagerType else {
            return
        }
        let fetchGroup = DispatchGroup()
        let queue = DispatchQueue.global()
        queue.async(group: fetchGroup) {
            petKeywordCoreDataManagerType.fetchOnlyPet { (petValue, error) in
                print("Step 1")
                if let error = error {
                    completion(false, error)
                }
                print("fetchOnlyPet: \(petValue)")
                if petValue == "강아지" {
                    PetDefault.shared.pet = .dog
                } else {
                    PetDefault.shared.pet = .cat
                }
            }
        }
        queue.async(group: fetchGroup) {
            myGoodsCoreDataManagerType.fetchObjects(pet: PetDefault.shared.pet.rawValue) { [weak self] (fetchResult, error) in
                  print("Step 2")
                if let error = error {
                completion(false, error)
                }
                if let myGoods = fetchResult as? [MyGoodsData] {
                    self?.myGoods = myGoods
                    print("fetchObjects: \(myGoods)")
                }
            }
        }
       queue.async(group: fetchGroup) {
            searchWordDoreDataManagerType.fetchOnlySearchWord(pet: PetDefault.shared.pet.rawValue) { [weak self] (searchWord, error) in
                  print("Step 3")
                if let error = error {
                    completion(false, error)
                }
                if let searchWord = searchWord {
                    self?.searches = searchWord
                }
                print("fetchOnlySearchWord: \(searchWord)")
            }
        }
        queue.async(group: fetchGroup) {
            petKeywordCoreDataManagerType.fetchObjects(pet: PetDefault.shared.pet.rawValue) { (petKeyword, error) in
                  print("Step 4")
                if let error = error {
                    completion(false, error)
                }
                if let objects = petKeyword as? [PetKeywordData] {
                    self.keyword = objects.first
                    print("fetchObjects: \(objects.first) ")
                }
            }
        }

        fetchGroup.notify(queue: .main) { [weak self] in
            print("Notify")
            guard let self = self else {
                return
            }
            guard let keyword = self.keyword else {
                return
            }
            let result = algorithmManagerType.makeRequestSearchWords(with: self.myGoods, words: self.searches, petKeyword: keyword, count: 4)
            self.recommandGoods = result
            self.mixedletSearches = algorithmManagerType.combinePet(PetDefault.shared.pet, and: self.recommandGoods)
            self.request {
                (isSuccess, error, _) in
                if let error = error {
                    completion(false, error)
                }
                print("isSucess: \(isSuccess)")
                if isSuccess {
                    completion(true, nil)
                } else {
                    completion(false, nil)
                }

            }
       }
    }

    func fetchPet(completion: @escaping (Error?) -> Void) {
        guard  let petKeywordCoreDataManagerType = petKeywordCoreDataManagerType else {
            return
        }
        petKeywordCoreDataManagerType.fetchOnlyPet { (petValue, error) in
            if let error = error {
                completion(error)
            }
            if petValue == "강아지" {
                PetDefault.shared.pet = .dog
                completion(nil)
            } else {
                PetDefault.shared.pet = .cat
                completion(nil)
            }
        }
    }

    func fetchMyGoods(completion: @escaping ([MyGoodsData]?, Error?) -> Void) {
        guard let myGoodsCoreDataManagerType = self.myGoodsCoreDataManagerType else {
            return
        }

        myGoodsCoreDataManagerType.fetchObjects(pet: PetDefault.shared.pet.rawValue) { [weak self] (fetchResult, error) in
            if let error = error {
                completion(nil, error)
            }
            if let myGoods = fetchResult as? [MyGoodsData] {
                self?.myGoods = myGoods
                completion(myGoods, nil)
            } else {
                completion(nil, nil)
            }
        }
    }

   func fetchSearchWord(completion: @escaping ([String]?, Error?) -> Void) {
        guard let searchWordDoreDataManagerType = self.searchWordDoreDataManagerType else {
            return
        }

        searchWordDoreDataManagerType.fetchOnlySearchWord(pet: PetDefault.shared.pet.rawValue) { [weak self] (searchWord, error) in
            if let error = error {
                completion(nil, error)
            }
            if let searchWord = searchWord {
                self?.searches = searchWord
                completion(searchWord, nil)
            } else {
                completion(nil, nil)
            }

        }
    }

    func fetchPetKeywords(completion: @escaping (PetKeywordData?, Error?) -> Void) {
        guard let petKeywordCoreDataManagerType =  self.petKeywordCoreDataManagerType else {
            return
        }
        petKeywordCoreDataManagerType.fetchObjects(pet: PetDefault.shared.pet.rawValue) { (petKeyword, error) in
            if let error = error {
                completion(nil, error)
            }
            if let objects = petKeyword as? [PetKeywordData] {
                self.keyword = objects.first
                completion(objects.first, nil)
            } else {
                completion(nil, nil)
            }

        }
    }

    func mixedWord() {
        guard let keyword = keyword else {
            return
        }
        guard let algorithmManagerType = algorithmManagerType else {
            return
        }
        let result = algorithmManagerType.makeRequestSearchWords(with: myGoods, words: searches, petKeyword: keyword, count: 4)
        recommandGoods = result
        mixedletSearches = algorithmManagerType.combinePet(PetDefault.shared.pet, and: recommandGoods)
    }

    func request(completion: @escaping (Bool, Error?, Int?) -> Void) {
        print("in Request")
        guard let search = mixedletSearches.popLast() else {
            return
        }
        let param = ShoppingParams(search: search, count: 20, start: 1, sort: .similar)
        print("params: \(param)")
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
                print("In Request data Item: \(datas.items)")
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

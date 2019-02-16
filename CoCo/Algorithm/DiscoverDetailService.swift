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
    private(set) var detailCategories = ["옷", "침대", "샤시미", "방석", "수제 간식", "사료", "간식", "후드", "통조림"]
    private(set) var colorChips = [UIColor(red: 1.0, green: 189.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0), UIColor(red: 186.0 / 255.0, green: 166.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0), UIColor(red: 250.0 / 255.0, green: 165.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0), UIColor(red: 166.0 / 255.0, green: 183.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)]

    var dataLists = [MyGoodsData]()
    var sortOption: SortOption = .similar
    var itemStart = 1
    var pet: Pet = .dog

    init(serachCoreData: SearchWordCoreDataManagerType, petCoreData: PetKeywordCoreDataManagerType, network: NetworkManagerType, algorithm: Algorithm) {
        searchCoreDataManager = serachCoreData
        petKeywordCoreDataManager = petCoreData
        networkManager = network
        algorithmManager = algorithm
    }

    func getShoppingData(search: String, completion: @escaping (_ isSuccess: Bool, NetworkErrors?) -> Void) {
        let searchWord = algorithmManager.combinePet(pet, and: search)
        let params = ShoppingParams(search: searchWord, count: 20, start: itemStart, sort: sortOption)

        DispatchQueue.global().async {
            self.networkManager.getAPIData(params, completion: { data in
                if data.items.isEmpty {
                    completion(false, NetworkErrors.noData)
                    return
                }
                if self.itemStart == 1 {
                    self.dataLists.removeAll()
                }
                for goods in data.items {
                    let title = self.algorithmManager.removeHTML(from: goods.title)
                    self.dataLists.append(MyGoodsData(pet: Pet.dog.rawValue, title: title, link: goods.link, image: goods.image, isFavorite: false, isLatest: true, price: goods.lprice, productID: goods.productId, searchWord: search, shoppingmall: goods.mallName))
                }
                completion(true, nil)
            }) {_ in completion(false, NetworkErrors.badInput)}
        }
    }

    func getDetailCategories(category: Category) {
        self.detailCategories = category.getData(pet: pet)
    }

    func paginations(completion: @escaping (_ isSuccess: Bool, NetworkErrors?) -> Void) {
        algorithmManager.pagination(index: itemStart) { isPaging, itemStart in
            if isPaging {
                self.itemStart = itemStart ?? 0
                self.getShoppingData(search: self.recentSearched ?? "", completion: { isSuccess, networkError in
                    completion(isSuccess, networkError)
                })
            } else {
                completion(false, NetworkErrors.noData)
            }
        }
    }

    /* 컨트롤러에서 그대로 복사하셔서 쓰시면 됩니다 :)
             func sortButtonTapped() {
             let actionSheet = UIAlertController(title: nil, message: "정렬 방식을 선택해주세요", preferredStyle: .actionSheet)
     
             let sortSim = UIAlertAction(title: "유사도순", style: .default) { _ in
             self.sortChanged(sort: .similar)
             }
             let sortAscending = UIAlertAction(title: "가격 오름차순", style: .default) { _ in
             self.sortChanged(sort: .ascending)
             }
             let sortDescending = UIAlertAction(title: "가격 내림차순", style: .default) { _ in
             self.sortChanged(sort: .descending)
             }
             let sortDate = UIAlertAction(title: "날짜순", style: .default) { _ in
             self.sortChanged(sort: .date)
             }
             let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
     
             actionSheet.addAction(sortSim)
             actionSheet.addAction(sortAscending)
             actionSheet.addAction(sortDescending)
             actionSheet.addAction(sortDate)
             actionSheet.addAction(cancel)
     
             present(actionSheet, animated: true, completion: nil)
             }
     
             func sortChanged(sort: SortOption) {
             self.searchService.sortOption = sort
             self.searchService.itemStart = 1
             self.searchService.getShoppingData(search: self.searchService.recentSearched ?? "") { isSuccess, err in
             if isSuccess {
             DispatchQueue.main.async {
             self.collectionView.reloadData()
             }
             } else {
             if err == NetworkErrors.noData {
             self.alert("데이터가 없습니다. 다른 검색어를 입력해보세요")
             } else {
             self.alert("네트워크 연결이 끊어졌습니다.")
             }
             }
             }
             }
             }
 */

}

//
//  MyGoodsService.swift
//  CoCo
//
//  Created by 최영준 on 13/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

/**
 MyGoodsViewConroller에서 사용되는 비즈니스 모델을 처리한다.
 
 최근 본 상품 및 찜한 상품을 코어데이터에서 가져오기 또는 삭제 동작을 수행한다.
 
 각각의 배열을 통해 가져온 상품 정보에 접근할 수 있다.
 ```
 private(set) var recentGoods = [MyGoodsData]()
 private(set) var favoriteGoods = [MyGoodsData]()
 ```
 - Author: [최영준](https://github.com/0jun0815)
 */
class MyGoodsService {
    // MARK: - Data
    var dataIsEmpty: Bool {
        return recentGoods.isEmpty && favoriteGoods.isEmpty
    }
    var startEditing = false
    private(set) var recentGoods = [MyGoodsData]()
    private(set) var favoriteGoods = [MyGoodsData]()

    // MARK: - Manager
    private var manager: MyGoodsCoreDataManagerType?
    private var pet: Pet?

    // MARK: - Initializer
    init(manager: MyGoodsCoreDataManagerType) {
        self.manager = manager
        PetKeywordCoreDataManager().fetchOnlyPet { [weak self] (fetchResult, error) in
            if let error = error {
                print(error)
            }
            guard let petString = fetchResult else {
                return
            }
            self?.pet = Pet(rawValue: petString)
        }
    }

    // MARK: - Fetch methods
    /// 상품을 불러와 각 배열에 할당한다.
    func fetchGoods(completion: @escaping (Error?) -> Void) {
        recentGoods.removeAll()
        favoriteGoods.removeAll()
        let queueGroup = DispatchGroup()
        queueGroup.enter()
        fetchRecentGoods { [weak self] (myGoods, error) in
            if let error = error {
                completion(error)
            }
            if let myGoods = myGoods {
                 self?.recentGoods = myGoods
            }
            queueGroup.leave()
        }
        queueGroup.enter()
        fetchFavoriteGoods { [weak self] (myGoods, error) in
            if let error = error {
                completion(error)
            }
            if let myGoods = myGoods {
                self?.favoriteGoods = myGoods
            }
            queueGroup.leave()
        }
        queueGroup.notify(queue: .main) {
            completion(nil)
        }
    }
    /// 좋아요(찜) 상품을 코어데이터에서 가져온다.
    private func fetchFavoriteGoods(completion: @escaping ([MyGoodsData]?, Error?) -> Void) {
        guard let manager = manager else {
            return
        }
        manager.fetchFavoriteGoods(pet: nil) { [weak self] (fetchResult, error) in
            if let error = error {
                completion(nil, error)
            }
            if var goods = fetchResult {
                // 최근 본 상품 순서로 정렬한다.
                goods.sort { (previous, next) -> Bool in
                    if let prevDate = previous.date, let nextDate = next.date {
                        return prevDate > nextDate
                    }
                    return previous > next
                }
                completion(goods, nil)

            } else {
                completion(nil, nil)
            }
        }
    }
    /// 최근 상품을 코어데이터에서 가져온다.
    private func fetchRecentGoods(completion: @escaping ([MyGoodsData]?, Error?) -> Void) {
        guard let manager = manager else {
            return
        }
        manager.fetchLatestGoods(pet: nil, isLatest: true, ascending: false) { [weak self](myGoods, error) in
            if let error = error {
                completion(nil, error)
            }
            if var goods = myGoods {
                // 최근 상품과 찜한 상품이 중복될 경우 제외시킨다.
                goods = goods.filter { !$0.isFavorite }
                while goods.count > 10 {
                    if var data = goods.popLast() {
                        data.isLatest = false
                        self?.deleteObject(data) { (_) in }
                    }
                }
                completion(goods, nil)
            } else {
                completion(nil, nil)
            }
        }

    }

    // MARK: - Delete methods
    /// index에 해당하는 MyGoodsData를 삭제한다. 컨트롤러에서 호출하여 사용한다.
    func deleteGoods(index: Int, completion: (() -> Void)? = nil) {
        // 최근 본 상품
        if index < 10, let data = recentGoods[safeIndex: index] {
            deleteRecentGoods(data) { (_) in
                completion?()
            }
            // 찜한 목록
        } else if let data = favoriteGoods[safeIndex: index - 10] {
            deleteFavoriteGoods(data) { (_) in
                completion?()
            }
        }

    }
    /// 최근 본 상품을 삭제한다.
    private func deleteRecentGoods(_ data: MyGoodsData, completion: @escaping(Bool) -> Void) {
        guard recentGoods.contains(data), let index = recentGoods.firstIndex(of: data) else {
            return
        }
        var removedData = recentGoods.remove(at: index)
        removedData.isLatest = false
        deleteObject(removedData) { (isSuccess) in
            if isSuccess {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    /// 좋아요(찜) 상품을 삭제한다.
    private func deleteFavoriteGoods(_ data: MyGoodsData, completion: @escaping(Bool) -> Void) {
        guard favoriteGoods.contains(data), let index = favoriteGoods.firstIndex(of: data) else {
            return
        }
        var removedData = favoriteGoods.remove(at: index)
        removedData.isLatest = false
        removedData.isFavorite = false
        deleteObject(removedData) { (isSuccess) in
            if isSuccess {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    /// 실제 코어데이터에서 삭제 처리하는 메서드. 삭제 처리는 앱 종료 시점에 처리 된다. (isFavorite, isLatest 둘다 false면 제거)
    private func deleteObject(_ data: MyGoodsData, completion: @escaping (Bool) -> Void) {
        guard let manager = manager else {
            return
        }
        manager.updateObject(data) { (isSuccess) in
            if isSuccess {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

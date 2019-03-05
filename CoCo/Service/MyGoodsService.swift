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
        if let data = try? PetKeywordCoreDataManager().fetchOnlyPet(), let string = data {
            pet = Pet(rawValue: string)
        }
    }

    // MARK: - Fetch methods
    /// 상품을 불러와 각 배열에 할당한다.
    func fetchGoods() {
        recentGoods.removeAll()
        favoriteGoods.removeAll()
        recentGoods = fetchRecentGoods()
        print(recentGoods)
        favoriteGoods = fetchFavoriteGoods()
        print(favoriteGoods)
    }
    /// 좋아요(찜) 상품을 코어데이터에서 가져온다.
    private func fetchFavoriteGoods() -> [MyGoodsData] {
        guard let manager = manager else {
            return []
        }
        var result = [MyGoodsData]()
        if let data = try? manager.fetchFavoriteGoods(pet: nil), let goods = data {
            result = goods
        }
        // 최근 본 상품 순서로 정렬한다.
        result.sort { (previous, next) -> Bool in
            if let prevDate = previous.date, let nextDate = next.date {
                return prevDate > nextDate
            }
            return previous > next
        }
        return result
    }
    /// 최근 상품을 코어데이터에서 가져온다.
    private func fetchRecentGoods() -> [MyGoodsData] {
        guard let manager = manager else {
            return []
        }
        var result = [MyGoodsData]()
        if let data = try? manager.fetchLatestGoods(pet: nil, isLatest: true, ascending: false),
            let goods = data {
            result = goods
        }
        // 최근 상품과 찜한 상품이 중복될 경우 제외시킨다.
        result = result.filter { !$0.isFavorite }
        while result.count > 10 {
            if var data = result.popLast() {
                data.isLatest = false
                _ = deleteObject(data)
            }
        }
        return result
    }

    // MARK: - Delete methods
    /// index에 해당하는 MyGoodsData를 삭제한다. 컨트롤러에서 호출하여 사용한다.
    func deleteGoods(index: Int, completion: (() -> Void)? = nil) {
        // 최근 본 상품
        if index < 10, let data = recentGoods[safeIndex: index] {
            deleteRecentGoods(data)
            // 찜한 목록
        } else if let data = favoriteGoods[safeIndex: index - 10] {
            deleteFavoriteGoods(data)
        }
        completion?()
    }
    /// 최근 본 상품을 삭제한다.
    @discardableResult private func deleteRecentGoods(_ data: MyGoodsData) -> Bool {
        guard recentGoods.contains(data), let index = recentGoods.firstIndex(of: data) else {
            return false
        }
        var removedData = recentGoods.remove(at: index)
        removedData.isLatest = false
        return deleteObject(removedData)
    }
    /// 좋아요(찜) 상품을 삭제한다.
    @discardableResult private func deleteFavoriteGoods(_ data: MyGoodsData) -> Bool {
        guard favoriteGoods.contains(data), let index = favoriteGoods.firstIndex(of: data) else {
            return false
        }
        var removedData = favoriteGoods.remove(at: index)
        removedData.isLatest = false
        removedData.isFavorite = false
        return deleteObject(removedData)
    }

    /// 실제 코어데이터에서 삭제 처리하는 메서드. 삭제 처리는 앱 종료 시점에 처리 된다. (isFavorite, isLatest 둘다 false면 제거)
    private func deleteObject(_ data: MyGoodsData) -> Bool {
        guard let manager = manager else {
            return false
        }
        if let result = try? manager.updateObject(data) {
            return result
        }
        return false
    }
}

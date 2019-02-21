//
//  MyGoodsService.swift
//  CoCo
//
//  Created by 최영준 on 13/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

class MyGoodsService {
    // MARK: - Data
    private(set) var recentGoods = [MyGoodsData]()
    private(set) var favoriteGoods = [MyGoodsData]()

    // MARK: - Manager
    private lazy var manager = MyGoodsCoreDataManager()
    private var pet: Pet?

    var dataIsEmpty: Bool {
        return recentGoods.isEmpty && favoriteGoods.isEmpty
    }

    // MARK: - Initializer
    init() {
        if let data = try? PetKeywordCoreDataManager().fetchOnlyPet(), let string = data {
            pet = Pet(rawValue: string)
        }
    }

    // MARK: - Fetch methods
    func fetchGoods() {
        // TODO: return 결과에 따른 true, false 처리 어떻게 할지 생각해보기
        recentGoods.removeAll()
        favoriteGoods.removeAll()
        recentGoods = fetchRecentGoods()
        favoriteGoods = fetchFavoriteGoods()
    }

    private func fetchFavoriteGoods() -> [MyGoodsData] {
        if let pet = pet, let data = try? manager.fetchFavoriteGoods(pet: pet.rawValue), let goods = data {
            return goods
        } else if let data = try? manager.fetchFavoriteGoods(), let goods = data {
            return goods
        }
        return []
    }

    private func fetchRecentGoods() -> [MyGoodsData] {
        var result = [MyGoodsData]()
        if let pet = pet,
            let data = try? manager.fetchLatestGoods(pet: pet.rawValue, isLatest: true, ascending: false),
            let goods = data {
            result = goods
        } else if let data = try? manager.fetchLatestGoods(isLatest: true, ascending: false),
            let goods = data {
            result = goods
        }
        if result.count > 10 {
            print(result.count)
            result.removeSubrange(10 ..< result.count)
        }
        return result
    }

    // MARK: - Delete methods
    @discardableResult func deleteRecentGoods(_ data: MyGoodsData) -> Bool {
        guard recentGoods.contains(data), let index = recentGoods.firstIndex(of: data) else {
            return false
        }
        var removedData = recentGoods.remove(at: index)
        removedData.isLatest = false
        return deleteGoods(removedData)
    }

    @discardableResult func deleteFavoriteGoods(_ data: MyGoodsData) -> Bool {
        guard favoriteGoods.contains(data), let index = favoriteGoods.firstIndex(of: data) else {
            return false
        }
        var removedData = favoriteGoods.remove(at: index)
        removedData.isFavorite = false
        return deleteGoods(removedData)
    }

    // 중요: 실제 코어데이터에서 삭제 처리는 앱이 종료 시점에 처리됌. (isFavorite, isLatest 둘다 false면 제거)
    private func deleteGoods(_ data: MyGoodsData) -> Bool {
        if let result = try? manager.updateObject(data), result {
            return result
        }
        return false
    }
}

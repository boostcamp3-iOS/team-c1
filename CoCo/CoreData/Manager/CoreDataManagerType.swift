//
//  CoreDataManager.swift
//  CoCo
//
//  Created by 강준영 on 28/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import CoreData
import UIKit

// MARK: - CoreDataManagerType
protocol CoreDataManagerType {
    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool
    func fetchObjects(pet: String?) throws -> [CoreDataStructEntity]?
    func updateObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool
    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool
}

// MARK: - MyGoodsCoreDataManagerType
protocol MyGoodsCoreDataManagerType: CoreDataManagerType {
    // MARK: - Methodes
    func fetchFavoriteGoods(pet: String?) throws -> [MyGoodsData]?
    func fetchLatestGoods(pet: String?, isLatest: Bool, ascending: Bool) throws -> [MyGoodsData]?
    func deleteFavoriteAllObjects(pet: String) throws -> Bool
    func deleteLatestAllObjects(pet: String, isLatest: Bool) throws -> Bool
}

// MARK: - PetKeywordCoreDataManagerType
protocol PetKeywordCoreDataManagerType: CoreDataManagerType {
    // MARK: - Methodes
    func fetchOnlyKeyword(pet: String) throws -> [String]?
    func fetchOnlyPet() throws -> String?
    func deleteAllObjects(pet: String) throws -> Bool
}

// MARK: - SearchWordCoreDataManagerType
protocol SearchWordCoreDataManagerType: CoreDataManagerType {
    // MARK: - Methodes// MARK: - Methodes
    func fetchOnlySearchWord(pet: String) throws -> [String]?
    func updateObject(searchWord: String, pet: String) throws -> Bool
    func deleteAllObjects(pet: String) throws -> Bool
}

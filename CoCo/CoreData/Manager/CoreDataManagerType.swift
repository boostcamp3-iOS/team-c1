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
    func fetchObjects(pet: Pet?) throws -> [CoreDataStructEntity]?
    func updateObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool
    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool
}

// MARK: - MyGoodsCoreDataManagerType
protocol MyGoodsCoreDataManagerType: CoreDataManagerType {
    // MARK: - Methodes
    func fetchFavoriteGoods(pet: Pet) throws -> [MyGoodsData]?
    func fetchLatestGoods(pet: Pet, isLatest: Bool, ascending: Bool) throws -> [MyGoodsData]?
    func deleteFavoriteAllObjects(pet: Pet) throws -> Bool
    func deleteLatestAllObjects(pet: Pet, isLatest: Bool) throws -> Bool
}

// MARK: - PetKeywordCoreDataManagerType
protocol PetKeywordCoreDataManagerType: CoreDataManagerType {
    // MARK: - Methodes
    func fetchOnlyKeyword(pet: Pet) throws -> [Keyword]?
    func fetchOnlyPet() throws -> Pet?
    func deleteAllObjects(pet: Pet) throws -> Bool
}

// MARK: - SearchWordCoreDataManagerType
protocol SearchWordCoreDataManagerType: CoreDataManagerType {
    // MARK: - Methodes// MARK: - Methodes
    func fetchOnlySearchWord(pet: Pet) throws -> [String]?
    func updateObject(searchWord: String, pet: Pet) throws -> Bool
    func deleteAllObjects(pet: Pet) throws -> Bool
}

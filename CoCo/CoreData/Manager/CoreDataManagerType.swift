//
//  CoreDataManager.swift
//  CoCo
//
//  Created by 강준영 on 28/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import CoreData
import UIKit

protocol CoreDataManagerType {
    // MARK: - Method
    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool
    func fetchObjects(pet: String?) throws -> [CoreDataStructEntity]?
    func updateObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool
    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool
}

protocol MyGoodsCoreDataManagerType: CoreDataManagerType {
    func fetchFavoriteGoods(pet: String) throws -> [MyGoodsData]?
    func fetchLatestGoods(pet: String) throws -> [MyGoodsData]?
    func deleteFavoriteAllObjects(pet: String, isFavorite: Bool) throws -> Bool
    func deleteLatestAllObjects(pet: String, isLatest: Bool) throws -> Bool
}

protocol PetKeywordCoreDataManagerType: CoreDataManagerType {
    func fetchOnlyKeyword(pet: String) throws -> [String]?
    func fetchOnlyPet(pet: String) throws -> String?
    func deleteAllObjects(pet: String) throws -> Bool
}

protocol SearchWordCoreDataManagerType: CoreDataManagerType {
    func fetchOnlySearchWord(pet: String) throws -> [String]?
    func updateObject(with searchWord: String, pet: String) throws -> Bool
    func deleteAllObjects(pet: String) throws -> Bool
}

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
    func fetchObjects() throws -> [CoreDataStructEntity]?
    func updateObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool
    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool
}

protocol MyGoodsCoreDataManagerType: CoreDataManagerType {
    func fetchFavoriteGoods() throws -> [MyGoodsData]?
    func fetchLatestGoods() throws -> [MyGoodsData]?
}

protocol PetKeywordCoreDataManagerType: CoreDataManagerType {
    func fetchOnlyKeyword() throws -> [String]?
    func fetchOnlyPet() throws -> String?
}

protocol SearchWordCoreDataManagerType: CoreDataManagerType {
    func fetchOnlySearchWord() throws -> [String]?
}






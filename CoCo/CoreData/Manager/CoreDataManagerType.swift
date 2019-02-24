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
protocol CommonCoreDataManagerType {
    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T, comepletion: @escaping (Bool, Error?) -> Void)
    func updateObject<T>(_ coreDataStructType: T,
                         completion: @escaping (Bool) -> Void)
    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T, completion: @escaping (Bool) -> Void)
}

// MARK: - MyGoodsCoreDataManagerType
protocol MyGoodsCoreDataManagerType {
    // MARK: - Methodes
    func fetchObjects(pet: String?, completion: @escaping ([CoreDataStructEntity]?, Error?) -> Void) 
    func fetchFavoriteGoods(pet: String?, completion: @escaping ([MyGoodsData]?, Error?) -> Void)
    func fetchLatestGoods(pet: String?, isLatest: Bool, ascending: Bool, completion: @escaping ([MyGoodsData]?, Error?) -> Void)
    func fetchProductID(productID: String, completion: @escaping (MyGoods?, Error?) -> Void)
    func deleteFavoriteAllObjects(pet: String, completion: @escaping (Bool, Error?) -> Void)
    func deleteLatestAllObjects(pet: String, isLatest: Bool, completion: @escaping (Bool, Error?) -> Void)
    func latestGoodsToFalse(pet: String, completion: @escaping (Error?) -> Void)
}

// MARK: - PetKeywordCoreDataManagerType
protocol PetKeywordCoreDataManagerType {
    // MARK: - Methodes
    func fetchObjects(pet: String?, completion: @escaping ([CoreDataStructEntity]?, Error?) -> Void)
    func fetchOnlyKeyword(pet: String, completion: @escaping ([String]?) -> Void)
    func fetchOnlyPet(completion: @escaping (String?, Error?) -> Void)
    func deleteAllObjects(pet: String, completion: @escaping (Bool, Error?) -> Void)
}

// MARK: - SearchWordCoreDataManagerType
protocol SearchWordCoreDataManagerType {
    // MARK: - Methodes// MARK: - Methodes
    func fetchObjects(pet: String?, completion: @escaping ([CoreDataStructEntity]?, Error?) -> Void)
    func fetchOnlySearchWord(pet: String, completion: @escaping ([String]?) -> Void)
    func fetchWord(_ searchWord: String, pet: String, completion: @escaping(SearchWordData?) -> Void)
    func updateObject(searchWord: String, pet: String, completion: @escaping (Bool) -> Void )
    func deleteAllObjects(pet: String, completion: @escaping (Bool, Error?) -> Void)
}

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
//    func fetchObjects<T: CoreDataEntity>(_ entityClass: T.Type, sortBy: [NSSortDescriptor]?, predicate: NSPredicate?) throws -> [T]?
    func fetch <T: CoreDataEntity>(_ coreDataType: T.Type, sortBy: [NSSortDescriptor]?, predicate: NSPredicate?) throws -> [T]?
    @discardableResult func insertCoreData<T: CoreDataEntity>(_ coreDataType: T) throws -> Bool
    @discardableResult func deleteObject<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate?) throws -> Bool
    @discardableResult func updateObject<T: CoreDataEntity>(_ coreDataType: T) throws -> Bool
}


protocol SearchKeywordCoreDataManagerType: CoreDataManagerType {
    func fetchOnlySearchWord() -> [String]?
}


protocol PetKeywordCoreDataManagerType: CoreDataManagerType {
    func fetchOnlyKeyword() throws -> [String]?
}

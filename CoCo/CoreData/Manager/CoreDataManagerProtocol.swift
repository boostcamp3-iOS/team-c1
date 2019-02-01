//
//  CoreDataManager.swift
//  CoCo
//
//  Created by 강준영 on 28/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    // MARK: - Method
    func fetchObjects<T: NSManagedObject>(_ entityClass: T.Type, sortBy: [NSSortDescriptor]?, predicate: NSPredicate?) throws -> [T]?
    @discardableResult func insertCoreData<T: CoreDataEntity>(_ coreDataType: T) throws -> Bool
    @discardableResult func deleteObject<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate?) throws -> Bool
    @discardableResult func updateObject<T: CoreDataEntity>(_ coreDataType: T) throws -> Bool
}


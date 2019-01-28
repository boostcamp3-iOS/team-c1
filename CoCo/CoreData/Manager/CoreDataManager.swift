//
//  CoreDataManager.swift
//  CoCo
//
//  Created by 강준영 on 28/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataManager {
    // MARK: - Properties
    var appDelegate: AppDelegate? { get }
    var context: NSManagedObjectContext? { get }

    // MARK: - Method
    func fetchObjects<T: NSManagedObject>(_ entityClass: T.Type, sortBy: [NSSortDescriptor]?, predicate: NSPredicate?) throws -> [T]?
    func insertCoreData<T: CoreDataEntity>(coreDataType: T)
    func deleteObject<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate?) throws -> Bool
}

extension CoreDataManager {
    //Define default properties
    weak var appDelegate: AppDelegate? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate
    }
    var context: NSManagedObjectContext? {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let context = appdelegate.persistentContainer.viewContext
        return context
    }
}

extension CoreDataManager {
    //Define default method
    func fetchObjects<T: NSManagedObject>(_ entityClass: T.Type, sortBy: [NSSortDescriptor]?, predicate: NSPredicate?) throws -> [T]? {
        guard let context = context else {
            return nil
        }
        let request: NSFetchRequest<T>
        if #available(iOS 10.0, *) {
            guard let tmpRequest = entityClass.fetchRequest() as? NSFetchRequest<T> else { return nil }
            request = tmpRequest
        } else {
            let entityName = String(describing: entityClass)
            request = NSFetchRequest(entityName: entityName)
        }

        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        request.sortDescriptors = sortBy

        let fetchedResult = try context.fetch(request)
        return fetchedResult
    }

    func deleteObject<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate?) throws -> Bool {
        guard let context = context else {
            return false
        }
        guard let appDelegate = appDelegate else {
            return false
        }
        var object: NSManagedObject?
        do {
            guard let fetchObject = try fetchObjects(entityClass.self, sortBy: nil, predicate: predicate) else {
                return false
            }
            guard let firstObject = fetchObject.first else {
                return false
            }
            object = firstObject
            if let object = object {
                context.delete(object)
                appDelegate.saveContext()
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            print("fetch error \(error)")
            return false
        }
    }

}

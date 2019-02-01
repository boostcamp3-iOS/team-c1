//
//  CoreDataManager.swift
//  CoCo
//
//  Created by 강준영 on 31/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataManager: CoreDataManagerType {
    // MARK: - Properties
    var appDelegate: AppDelegate? { get }
    var context: NSManagedObjectContext? { get }
    func afterOperation(context: NSManagedObjectContext?)
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

protocol CoreDataManagerFunctionImplementType: CoreDataManagerType {
    
}

extension CoreDataManagerFunctionImplementType {
    // MARK: - Fetch Method
    // Define default method
    @discardableResult func fetchObjects<T: NSManagedObject>(_ entityClass: T.Type, sortBy: [NSSortDescriptor]?, predicate: NSPredicate?) throws -> [T]? {
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
    
    // MARK: - Delete Method
    @discardableResult func deleteObject<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate?) throws -> Bool {
        guard let context = context else {
            return false
        }
        guard let appDelegate = appDelegate else {
            return false
        }
        
        do {
            guard let fetchObject = try fetchObjects(entityClass.self, sortBy: nil, predicate: predicate) else {
                return false
            }
            if let firstObject = fetchObject.first {
                context.delete(firstObject)
                appDelegate.saveContext()
                return true
            } else {
                throw CoreDataError.delete(message: "Can not fetch Data")
            }
        } catch let error as NSError {
            print("fetch error \(error)")
            return false
        }
    }
    
    // MARK: - Util Method
    // 데이터의 연산결과가 반영되게 하는 함수
    func afterOperation(context: NSManagedObjectContext?) {
        guard let context = context else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
}

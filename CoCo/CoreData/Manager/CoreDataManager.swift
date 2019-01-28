//
//  CoreDataManager.swift
//  CoCo
//
//  Created by 강준영 on 25/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    // MARK: - Properties
    static let shared = CoreDataManager()
    private weak var appDelegate: AppDelegate? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate
    }()
    private let context: NSManagedObjectContext? = {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let context = appdelegate.persistentContainer.viewContext
        return context
    }()

    // MARK: - Method
    // MARK: - CoreData Func
    // Create MyGoods CoreData
    func insertCoreData<T: CoreDataEntity>(coreDataType: T) {
        let myGoodsData = coreDataType
        guard let appDelegate = appDelegate else {
            return
        }
        guard let context = context else {
            return
        }

        switch coreDataType {
        case is MyGoodsData:
            guard let myGoodsData = coreDataType as? MyGoodsData else {
                return
            }
            let myGoods = MyGoods(context: context)
                myGoods.date = myGoodsData.date as NSDate
                myGoods.title = myGoodsData.title
                myGoods.link = myGoodsData.link
                myGoods.image = myGoodsData.image
                myGoods.isFavorite = myGoodsData.isFavorite
                myGoods.price = myGoodsData.price
                myGoods.productId = myGoodsData.productId
                appDelegate.saveContext()
        default:
            break
        }

    }

    // MARK: - Fetch CoreData Func
    // Fetch MyGoods CoreData
    private func fetchObjects<T: NSManagedObject>(_ entityClass: T.Type,
                                                  sortBy: [NSSortDescriptor]? = nil,
                                                  predicate: NSPredicate? = nil) throws -> [T]? {
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

    // Fetch MyGoods CoreData
    private func fetchGoods(isFavorite: Bool) -> [MyGoods]? {
        let sort = NSSortDescriptor(key: #keyPath(MyGoods.date), ascending: true)
        let predicate = NSPredicate(format: isFavorite ? "isFavorite = true" : "isFavorite = false")
        do {
            guard let fetchResult = try fetchObjects(MyGoods.self, sortBy: [sort], predicate: predicate) else {
                return nil
            }
            return fetchResult
        } catch let error as NSError {
            return nil
        }
    }

    func fetchGoods(isFavoriteGoods: Bool) -> [MyGoodsData] {
        guard let objects = fetchGoods(isFavorite: isFavoriteGoods) else {
            return []
        }
        var myGoodsData: [MyGoodsData] = []
        for index in objects.indices {
            let tempObject = objects[index]
            myGoodsData.append(MyGoodsData(date: tempObject.date as Date, title: tempObject.title, link: tempObject.link, image: tempObject.image, isFavorite: tempObject.isFavorite, price: tempObject.price, productId: tempObject.productId))
        }
        return myGoodsData
    }

    // MARK: - Delete CoreData
    // Delete FavoriteKeywords CoreData
    private func deleteObject<T: NSManagedObject>(_ entityClass: T.Type, predicate: NSPredicate? = nil) throws -> Bool {
        guard let context = context else {
            return false
        }
        guard let appDelegate = appDelegate else {
            return false
        }
        var object: NSManagedObject?
        do {
            guard let fetchObject = try fetchObjects(entityClass.self, predicate: predicate) else {
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
            return false
        }
    }

    // delete My Goods Data
    func deleteMyGoods(id: String) {
        let predicate = NSPredicate(format: "productId = %@", id)
        do {
            let delete = try deleteObject(MyGoods.self, predicate: predicate)
            if delete {
                print("delete successive")
            } else {
                print("delete fail")
            }
        } catch let error as NSError {
            print("delete error")
        }
    }

    // update MyGoods Coredata
    func updateMyGoods(id: String) {
        let predicate = NSPredicate(format: "productId = %@ AND isFavorite = true", id)
        do {
            guard let fetchResult = try fetchObjects(MyGoods.self, predicate: predicate) else {
                return
            }
            guard let object = fetchResult.first else { return }
            object.setValue(false, forKey: "isFavorite")
            preUpdateMyGoods(result: object)
            return
        } catch let error as NSError {
            return
        }
    }

    private func preUpdateMyGoods(result: MyGoods) {
        let sort = NSSortDescriptor(key: #keyPath(MyGoods.date), ascending: true)
        let predicate = NSPredicate(format: "isFavorite = false")
        let favoriteGoodsDate = result.date
        var lastestGoodsDate = Date()
        do {
            guard let objects = try fetchObjects(MyGoods.self, sortBy: [sort], predicate: predicate) else {
                return
            }
            guard let object = objects.first else {
                return
            }
            lastestGoodsDate = object.date as Date

            if favoriteGoodsDate.compare(lastestGoodsDate) == .orderedAscending {
                deleteMyGoods(id: result.productId)
            } else if favoriteGoodsDate.compare(lastestGoodsDate) == .orderedDescending {
                deleteMyGoods(id: object.productId)
            }

        } catch let error as NSError {

        }

    }

}

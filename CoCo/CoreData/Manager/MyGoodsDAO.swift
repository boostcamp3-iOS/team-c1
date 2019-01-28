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

class MyGoodsDAO: CoreDataManager {

    // MARK: - Properties
    static let shared = MyGoodsDAO()
    private var dataArray: [CoreDataEntity] = []

    func insertCoreData<T: CoreDataEntity>(coreDataType: T) {
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
            let object = fetchObjectId(productId: myGoodsData.productId)
            if object == nil {
                let myGoods = myGoodsData.toCoreData(context: context)
                print("succesive insert \(myGoods)")
            } else {
                guard let object = object else { return }
                if object.isTwoAttribute {
                    print("Already inserted")
                } else {
                    // update isTwoAttribute to true
                }
            }
        default:
            break
        }
        appDelegate.saveContext()

    }

    // MARK: - Fetch CoreData Func
    // Fetch MyGoods CoreData
    func fetchAll() -> [NSManagedObject]? {
        do {
            let objects = try fetchObjects(MyGoods.self, sortBy: nil, predicate: nil)
            return objects
        } catch let error as NSError {
            print("fetch error \(error)")
            return nil
        }
    }

    // Fetch MyGoods CoreData
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

    private func fetchGoods(isFavorite: Bool) -> [MyGoods]? {
        let sort = NSSortDescriptor(key: #keyPath(MyGoods.date), ascending: true)
        let predicate = NSPredicate(format: isFavorite ? "isFavorite = true" : "isFavorite = false")
        do {
            guard let fetchResult = try fetchObjects(MyGoods.self, sortBy: [sort], predicate: predicate) else {
                return nil
            }
            return fetchResult
        } catch let error as NSError {
            print("fetch error \(error)")
            return nil
        }
    }

    private func fetchObjectId(productId: String) -> MyGoods? {
        let predicate = NSPredicate(format: "productId = %@", productId)
        do {
            guard let object = try fetchObjects(MyGoods.self, sortBy: nil, predicate: predicate) else {
                return nil
            }
            guard let first = object.first else {
                return nil
            }
            return first
        } catch let error {
            print("fetch error \(error)")
            return nil
        }

    }

    // delete My Goods Data
    func deleteMyGoods(productId: String) {
        let predicate = NSPredicate(format: "productId = %@", productId)
        do {
            let delete = try deleteObject(MyGoods.self, predicate: predicate)
            if delete {
                print("delete successive")
            } else {
                print("delete fail")
            }
        } catch let error as NSError {
            print("delete error \(error)")
        }
    }
}

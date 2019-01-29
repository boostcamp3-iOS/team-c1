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

    func insertCoreData<T: CoreDataEntity>(coreDataType: T) throws -> Bool {
        guard let context = context else {
            return false
        }

        switch coreDataType {
        case is MyGoodsData:
            guard let myGoodsData = coreDataType as? MyGoodsData else {
                return false
            }
            let object = fetchObjectId(productId: myGoodsData.productId)

            // 해당 아이디가 존재하지 않을 때
            if object == nil {
                let myGoods = myGoodsData.toCoreData(context: context)
                afterOperation(context: context)
                print("succesive insert \(myGoodsData.productId)")
                return true
            } else {
                updateAll(myGoodsData: myGoodsData)
                print("Already Inserted , So Update")
                return false
                }
        default:
            break
        }
        return false
    }

    // MARK: - Fetch MyGoods Func
    // Fetch MyGoods
    func fetchAll() -> [MyGoodsData]? {
        var dataResults: [MyGoodsData] = []
        let sort = NSSortDescriptor(key: #keyPath(MyGoods.productId), ascending: true)
        do {
            guard let objects = try fetchObjects(MyGoods.self, sortBy: [sort], predicate: nil) else { return  nil}
            for object in objects {
                var myGoodsData = MyGoodsData()
                myGoodsData.date = object.date as Date
                myGoodsData.image = object.image
                myGoodsData.isFavorite = object.isFavorite
                myGoodsData.isLatest =  object.isLatest
                myGoodsData.link = object.link
                myGoodsData.objectId = object.objectID
                myGoodsData.price = object.price
                myGoodsData.productId = object.productId
                myGoodsData.searchWord = object.searchWord
                dataResults.append(myGoodsData)
            }
            return dataResults
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
            let myData = MyGoodsData()
            myGoodsData.append(MyGoodsData(date: tempObject.date as Date, title: tempObject.title, link: tempObject.link, image: tempObject.image, isFavorite: tempObject.isFavorite, isLatest: tempObject.isLatest, price: tempObject.price, productId: tempObject.productId, objectId: tempObject.objectID, searchWord: tempObject.searchWord))
        }
        return myGoodsData
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

    // Update MyGoods
     func updateAll (myGoodsData: MyGoodsData) {
        print("update \(myGoodsData.objectId)")
        guard let objectID = myGoodsData.objectId else { return }
        guard let context = context else { return }
        guard let object = context.object(with: objectID) as? MyGoods
                else { return }
        object.date = myGoodsData.date as NSDate
        object.isLatest = myGoodsData.isLatest
        object.isFavorite = myGoodsData.isFavorite
        object.title = myGoodsData.title
        object.image = myGoodsData.image
        object.link = myGoodsData.link
        object.price = myGoodsData.price
        object.searchWord = myGoodsData.searchWord

        afterOperation(context: context)
    }

    // delete My Goods Data
    func deleteMyGoods(myGoodsData: MyGoodsData) throws {
        guard let context = context else { return  }
        guard let objectID = myGoodsData.objectId else { return }
        print(context.object(with: objectID))
        guard let object = context.object(with: objectID) as? MyGoods else { return }
        if object != nil {
            context.delete(object)
            afterOperation(context: context)
            print("delete success")
        } else {
            print("Delete fail")
        }
    }

    func deleteMyGoods(productId: String) {
        guard let context = context else { return  }
        let predicate = NSPredicate(format: "productId = %@", productId)
        do {
            let delete = try deleteObject(MyGoods.self, predicate: predicate)
            if delete {
                print("delete success")
            } else {
                print("delete fail")
            }
        } catch let error as NSError {
            print("")
        }
    }
}

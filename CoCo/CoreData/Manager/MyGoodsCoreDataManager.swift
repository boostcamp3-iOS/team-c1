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

class MyGoodsCoreDataManager: MyGoodsCoreDataManagerType, CoreDataManagerFunctionImplementType {
    func fetch<T>(_ coreDataType: T.Type, sortBy: [NSSortDescriptor]?, predicate: NSPredicate?) throws -> [T]? where T : CoreDataEntity {
        return nil
    }
    
   
    // MARK: - Properties
    let appDelegate: AppDelegate?
    let context: NSManagedObjectContext?
    
    init(appDelegate: AppDelegate, context: NSManagedObjectContext) {
        self.appDelegate = appDelegate
        self.context = context
    }

    // MARK: - Methodes
    // MARK: - Insert Method
    @discardableResult func insertCoreData<T: CoreDataEntity>(_ coreDataType: T) throws -> Bool {
        guard let context = context else {
            return false
        }

        switch coreDataType {
        case is MyGoodsData:
            guard let myGoodsData = coreDataType as? MyGoodsData else {
                return false
            }
            // 삽입하려는 데이터와 동일한 데이터가 MyGoods Entity에 존재하는 지 확인하기 위해
            // 삽입하려는 데이터의 productID를 Entity에 존재하는 지 확인
            let object = fetchObjectId(productId: myGoodsData.productId)

            // 삽입하려는 데이터의 productID와 동일한 데이터가 없는 경우 삽입을 진행
            if object == nil {
                afterOperation(context: context)
                print("succesive insert \(myGoodsData.productId)")
                return true
                // 삽입하려는 데이터와 동일한 productID가 존재하면 기존 데이터 업데이트
            } else {
                try updateMyGoods(myGoodsData: myGoodsData)
                print("Already Inserted , So Update")
                return true
                }
        default:
            break
        }
        return false
    }

    // MARK: - Fetch Methodes
    // Fetch All MyGoods Data - MyGoods의 모든 데이터를 가져옴
    func fetchMyGoodsDatas() throws -> [MyGoodsData]? {
        var dataResults: [MyGoodsData] = []
        let sort = NSSortDescriptor(key: #keyPath(MyGoods.productId), ascending: true)
        do {
            guard let objects = try fetchObjects(MyGoods.self, sortBy: [sort], predicate: nil) else {
                throw CoreDataError.fetch(message: "MyGoods Entity has not data, So can not fetch data")
            }
            for object in objects {
                var myGoodsData = MyGoodsData()
                myGoodsData.date = object.date
                myGoodsData.image = object.image
                myGoodsData.isFavorite = object.isFavorite
                myGoodsData.isLatest =  object.isLatest
                myGoodsData.link = object.link
                myGoodsData.objectID = object.objectID
                myGoodsData.price = object.price
                myGoodsData.productId = object.productId
                myGoodsData.searchWord = object.searchWord
                myGoodsData.shoppingmall = object.shoppingmall
                dataResults.append(myGoodsData)
            }
            return dataResults
        } catch let error as NSError {
            print("fetch error \(error)")
            return nil
        }
    }

    // Fetch Favorite Datas - 즐겨찾기 한 모든 데이터를 가져옴
    func fetchFavoriteGoods() throws -> [MyGoodsData]? {
        // 즐겨찾기 한 상품 오름차순으로 정렬
        let sort = NSSortDescriptor(key: #keyPath(MyGoods.date), ascending: true)
        let predicate = NSPredicate(format: "isFavorite = true")
        var myGoodsDatas: [MyGoodsData] = []
        do {
            guard let objects = try fetchObjects(MyGoods.self, sortBy: [sort], predicate: predicate) else {
                throw CoreDataError.fetch(message: "MyGoods Entity has not favorite data, So can not fetch favorite data")
            }
            if objects.count > 0 {
                for index in objects.indices {
                    let tempObject = objects[index]
                    var myGoodsData = MyGoodsData()
                    myGoodsData.date = tempObject.date
                    myGoodsData.image = tempObject.image
                    myGoodsData.isFavorite = tempObject.isFavorite
                    myGoodsData.isLatest = tempObject.isLatest
                    myGoodsData.link = tempObject.link
                    myGoodsData.objectID = tempObject.objectID
                    myGoodsData.price = tempObject.price
                    myGoodsData.productId = tempObject.productId
                    myGoodsData.searchWord = tempObject.searchWord
                    myGoodsData.title = tempObject.title
                    myGoodsData.shoppingmall = tempObject.shoppingmall
                    myGoodsDatas.append(myGoodsData)
                }
                return myGoodsDatas
            } else {
                throw CoreDataError.fetch(message: "MyGoods Entity has not favorite data, So can not fetch favorite data")
            }
        } catch let error as NSError {
                print("fetch error \(error)")
        }
        return nil
    }

    // Fetch Latest Datas - 최근본 상품을 모두 가져옴
    func fetchLatestGoods() throws -> [MyGoodsData]? {
        // 오름차순으로 정렬
        let sort = NSSortDescriptor(key: #keyPath(MyGoods.date), ascending: true)
        let predicate = NSPredicate(format: "isLatest = true")
        var myGoodsDatas: [MyGoodsData] = []
        do {
            guard let objects = try fetchObjects(MyGoods.self, sortBy: [sort], predicate: predicate) else {
                throw CoreDataError.fetch(message: "MyGoods Entity has not latest data, So can not fetch favorite data")
            }
            if objects.count > 0 {
                for index in objects.indices {
                    let tempObject = objects[index]
                    var myGoodsData = MyGoodsData()
                    myGoodsData.date = tempObject.date
                    myGoodsData.image = tempObject.image
                    myGoodsData.isFavorite = tempObject.isFavorite
                    myGoodsData.isLatest = tempObject.isLatest
                    myGoodsData.link = tempObject.link
                    myGoodsData.objectID = tempObject.objectID
                    myGoodsData.price = tempObject.price
                    myGoodsData.productId = tempObject.productId
                    myGoodsData.searchWord = tempObject.searchWord
                    myGoodsData.title = tempObject.title
                    myGoodsData.shoppingmall = tempObject.shoppingmall
                    myGoodsDatas.append(myGoodsData)
                }
                return myGoodsDatas
            } else {
                throw CoreDataError.fetch(message: "MyGoods Entity has not latest data, So can not fetch favorite data")
            }
        } catch let error as NSError {
            print("fetch error \(error)")
        }
        return nil
    }

    // Fetch MyGoods Data using productID - 동일한 상품이 Entity에 존재하는 지 확인
    private func fetchObjectId(productId: String) -> MyGoods? {
        let predicate = NSPredicate(format: "productId = %@", productId)
        do {
            guard let object = try fetchObjects(MyGoods.self, sortBy: nil, predicate: predicate) else {
                // 기존에 동일한 product가 존재 하는 지 아닌 지 확인하기위해 오류를 던지지 않음
                return nil
            }
            guard let first = object.first else {
                throw CoreDataError.fetch(message: "MyGoods Entity has not \(productId) data, So can not fetch data")
            }
            return first
        } catch let error as NSError {
            print("fetch error \(error)")
            return nil
        }
    }

    // MARK: - Update Method
    // Update MyGoods All - 모든 내용을 업데이트한다.
     @discardableResult func updateMyGoods (myGoodsData: MyGoodsData) throws -> Bool {
        guard let objectID = myGoodsData.objectID else { throw CoreDataError.update(message: "Can not find data, So can not update")
        }
        guard let context = context else { return  false }
        guard let object = context.object(with: objectID) as? MyGoods
            else { throw CoreDataError.update(message: "Can not find data, So can not update")
        }
        guard let date = myGoodsData.date else { return false }
        object.date = date
        object.isLatest = myGoodsData.isLatest
        object.isFavorite = myGoodsData.isFavorite
        object.title = myGoodsData.title
        object.image = myGoodsData.image
        object.link = myGoodsData.link
        object.price = myGoodsData.price
        object.searchWord = myGoodsData.searchWord
        object.shoppingmall = myGoodsData.shoppingmall
        afterOperation(context: context)
        return true
    }
    
    func updateObject<T>(_ coreDataType: T) throws -> Bool where T : CoreDataEntity {
        return false
    }

    // MARK: - Delete Method
    // delete My Goods Data
    @discardableResult func deleteMyGoods(myGoodsData: MyGoodsData) throws -> Bool {
        guard let context = context else { return false }
        if let objectID = myGoodsData.objectID {
            let object = context.object(with: objectID)
            context.delete(object)
            afterOperation(context: context)
            return true
        } else {
            throw CoreDataError.delete(message: "Can not found data, So can not delete.")
        }
    }
}

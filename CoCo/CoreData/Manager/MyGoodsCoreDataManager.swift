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
    
    // MARK: - Methodes
    // MARK: - Insert Method
    @discardableResult func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool  {
        switch coreDataStructType {
        case is MyGoodsData:
            guard let context = context else { return false }
            guard let myGoodsData = coreDataStructType as? MyGoodsData else {
                return false
            }
            // 삽입하려는 데이터와 동일한 데이터가 MyGoods Entity에 존재하는 지 확인하기 위해
            // 삽입하려는 데이터의 productID를 Entity에 존재하는 지 확인
            let fetchObject = fetchProductId(productId: myGoodsData.productId)

            // 삽입하려는 데이터의 productID와 동일한 데이터가 없는 경우 삽입을 진행
            if fetchObject == nil {
                let object = MyGoods()
                object.date =  myGoodsData.date ?? ""
                object.title = myGoodsData.title
                object.image = myGoodsData.image
                object.isFavorite = myGoodsData.isFavorite
                object.isLatest = myGoodsData.isLatest
                object.link = myGoodsData.link
                object.price = myGoodsData.price
                object.productId = myGoodsData.productId
                object.searchWord = myGoodsData.searchWord ?? ""
                object.shoppingmall = myGoodsData.shoppingmall
                object.pet = myGoodsData.pet
                afterOperation(context: context)
                print("succesive insert \(myGoodsData.productId)")
                return true
                // 삽입하려는 데이터와 동일한 productID가 존재하면 기존 데이터 업데이트
            } else {
                try updateObject(myGoodsData)
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
    func fetchObjects(pet: String? = nil) throws -> [CoreDataStructEntity]? {
        guard let context = context else { return nil }
        let sort = NSSortDescriptor(key: #keyPath(MyGoods.date), ascending: true)
        var myGoodsDatas: [MyGoodsData] = []
        let request: NSFetchRequest<MyGoods>
        
        if #available(iOS 10.0, *) {
            let tmpRequest: NSFetchRequest<MyGoods> = MyGoods.fetchRequest()
            request = tmpRequest
        } else {
            let entityName = String(describing: MyGoods.self)
            request = NSFetchRequest(entityName: entityName)
        }
        
        if pet != nil {
            let predicate = NSPredicate(format: "pet = %@", pet!)
            request.predicate = predicate
        }
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [sort]
        
        let objects = try context.fetch(request)
        
        if objects.count > 0 {
            for object in objects {
                var myGoodsData = MyGoodsData()
                myGoodsData.date = object.date
                myGoodsData.image = object.image
                myGoodsData.isFavorite = object.isFavorite
                myGoodsData.isLatest = object.isLatest
                myGoodsData.link = object.link
                myGoodsData.objectID = object.objectID
                myGoodsData.price = object.price
                myGoodsData.productId = object.productId
                myGoodsData.searchWord = object.searchWord
                myGoodsData.title = object.title
                myGoodsData.shoppingmall = object.shoppingmall
                myGoodsData.pet = object.pet
                myGoodsDatas.append(myGoodsData)
            }
            return myGoodsDatas
        } else {
            throw CoreDataError.fetch(message: "MyGoods Entity has not data, So can not fetch data")
        }
    }
    
    // Fetch Favorite Datas - 즐겨찾기 한 모든 데이터를 가져옴
    func fetchFavoriteGoods(pet: String) throws -> [MyGoodsData]? {
        guard let context = context else {
            return nil
        }
        // 즐겨찾기 한 상품 오름차순으로 정렬
        let sort = NSSortDescriptor(key: #keyPath(MyGoods.date), ascending: true)
        let predicate = NSPredicate(format: "pet = %@ AND isFavorite = true", pet)
        var myGoodsDatas: [MyGoodsData] = []
        let request: NSFetchRequest<MyGoods>
        
        if #available(iOS 10.0, *) {
            let tmpRequest: NSFetchRequest<MyGoods> = MyGoods.fetchRequest()
            request = tmpRequest
        } else {
            let entityName = String(describing: MyGoods.self)
            request = NSFetchRequest(entityName: entityName)
        }
        
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        request.sortDescriptors = [sort]
        
        let objects = try context.fetch(request)
        
        if objects.count > 0 {
            for object in objects {
                var myGoodsData = MyGoodsData()
                myGoodsData.date = object.date
                myGoodsData.image = object.image
                myGoodsData.isFavorite = object.isFavorite
                myGoodsData.isLatest = object.isLatest
                myGoodsData.link = object.link
                myGoodsData.objectID = object.objectID
                myGoodsData.price = object.price
                myGoodsData.productId = object.productId
                myGoodsData.searchWord = object.searchWord
                myGoodsData.title = object.title
                myGoodsData.shoppingmall = object.shoppingmall
                myGoodsDatas.append(myGoodsData)
            }
            return myGoodsDatas
        } else {
            throw CoreDataError.fetch(message: "MyGoods Entity has not Favorite data, So can not fetch data")
        }
    }

    // Fetch Latest Datas - 최근본 상품을 모두 가져옴
    func fetchLatestGoods(pet: String) throws -> [MyGoodsData]? {
        guard let context = context else { return nil }
        // 오름차순으로 정렬
        let sort = NSSortDescriptor(key: #keyPath(MyGoods.date), ascending: true)
        let predicate = NSPredicate(format: "pet = %@ AND isLatest = true", pet)
        var myGoodsDatas: [MyGoodsData] = []
        let request: NSFetchRequest<MyGoods>
        
        if #available(iOS 10.0, *) {
            let tmpRequest: NSFetchRequest<MyGoods> = MyGoods.fetchRequest()
            request = tmpRequest
        } else {
            let entityName = String(describing: MyGoods.self)
            request = NSFetchRequest(entityName: entityName)
        }
        
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        request.sortDescriptors = [sort]
        
        let objects = try context.fetch(request)
        
        if objects.count > 0 {
            for object in objects {
                var myGoodsData = MyGoodsData()
                myGoodsData.date = object.date
                myGoodsData.image = object.image
                myGoodsData.isFavorite = object.isFavorite
                myGoodsData.isLatest = object.isLatest
                myGoodsData.link = object.link
                myGoodsData.objectID = object.objectID
                myGoodsData.price = object.price
                myGoodsData.productId = object.productId
                myGoodsData.searchWord = object.searchWord
                myGoodsData.title = object.title
                myGoodsData.shoppingmall = object.shoppingmall
                myGoodsDatas.append(myGoodsData)
            }
            return myGoodsDatas
        } else {
            throw CoreDataError.fetch(message: "MyGoods Entity has not data, So can not fetch data")
        }
    }

    // Fetch MyGoods Data using productID - 동일한 상품이 Entity에 존재하는 지 확인
    private func fetchProductId(productId: String) -> MyGoods? {
        guard let context = context else { return nil }
        let request: NSFetchRequest<MyGoods>
    
        if #available(iOS 10.0, *) {
            let tmpRequest: NSFetchRequest<MyGoods> = MyGoods.fetchRequest()
            request = tmpRequest
        } else {
            let entityName = String(describing: MyGoods.self)
            request = NSFetchRequest(entityName: entityName)
        }

        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "productId = %@", productId)

        do {
            let object = try context.fetch(request)
            guard let firstObject = object.first else {
                throw CoreDataError.fetch(message: "MyGoods Entity has not \(productId) data, So can not fetch data")
            }
            return firstObject
        } catch let error as NSError {
            print("fetch error \(error)")
            return nil
        }
    }

    // MARK: - Update Method
    // Update MyGoods All - 모든 내용을 업데이트한다.
   @discardableResult func updateObject<T>(_ coreDataStructType: T) throws -> Bool  {
        switch coreDataStructType {
        case is MyGoodsData:
            guard let context = context else { return  false }
            guard let myGoodsData = coreDataStructType as? MyGoodsData else {
                return false
            }
            guard let objectID = myGoodsData.objectID else { throw CoreDataError.update(message: "Can not find data, So can not update")
            }
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
            object.pet = myGoodsData.pet
            afterOperation(context: context)
            return true
            
        default:
            return false
        }
    }
    
    // MARK: - Delete Method
    // delete My Goods Data
    @discardableResult func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        switch coreDataStructType {
        case is MyGoodsData:
            guard let context = context else { return false }
            guard let object = coreDataStructType as? MyGoodsData else { return false }
            if let objectID = object.objectID {
                let deleteObjet = context.object(with: objectID)
                context.delete(deleteObjet)
                afterOperation(context: context)
                return true
            } else {
               throw CoreDataError.delete(message: "Can not found data, So can not delete.")
            }
        default:
            return false
        }
    }
    
    @discardableResult func deleteFavoriteAllObjects(pet: String, isFavorite: Bool) throws -> Bool {
        guard let context = context else { return false }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyGoods")
        let predicate = NSPredicate(format: "pet = %@ AND isFavorite = true", pet)
        
        fetchRequest.predicate = predicate
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            return true
            
        } catch {
            throw CoreDataError.delete(message: "Can't delete data")
        }
    }
    
    @discardableResult func deleteLatestAllObjects(pet: String, isLatest: Bool) throws -> Bool {
        guard let context = context else { return false }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyGoods")
        let predicate = NSPredicate(format: "pet = %@ AND isLatest = true", pet)
        
        fetchRequest.predicate = predicate
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            return true
            
        } catch {
            throw CoreDataError.delete(message: "Can't delete data")
        }
    }
    
}




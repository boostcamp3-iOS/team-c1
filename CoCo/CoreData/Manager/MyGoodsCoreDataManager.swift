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
    // MARK: - Insert Method
    /**
     MyGoods Entity에 데이터 삽입.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
        - coreDataStructType: coreDataStructType 프로토콜을 채택하는 CoreData Struct.
     */
    @discardableResult func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        switch coreDataStructType {
        case is MyGoodsData:
            guard let context = context else {
                return false
            }
            guard var myGoodsData = coreDataStructType as? MyGoodsData else {
                return false
            }
            // 삽입하려는 데이터와 동일한 productID가 존재하면 기존 데이터 업데이트
            if let object = fetchProductId(productId: myGoodsData.productID) {
                myGoodsData.objectID = object.objectID
                print("Product: \(myGoodsData.productID) Already Inserted , So Update")
                try updateObject(myGoodsData)
                return true
                // 삽입하려는 데이터와 동일한 데이터가 MyGoods Entity에 존재하는 지 확인하기 위해 삽입하려는 데이터의 productID를 Entity에 존재하는 지 확인.
                // 삽입하려는 데이터의 productID와 동일한 데이터가 없는 경우 삽입을 진행
            } else {
                let myGoods = MyGoods(context: context)
                myGoods.date =  myGoodsData.date ?? ""
                myGoods.title = myGoodsData.title
                myGoods.image = myGoodsData.image
                myGoods.isFavorite = myGoodsData.isFavorite
                myGoods.isLatest = myGoodsData.isLatest
                myGoods.link = myGoodsData.link
                myGoods.price = myGoodsData.price
                myGoods.productId = myGoodsData.productID
                myGoods.searchWord = myGoodsData.searchWord ?? ""
                myGoods.shoppingmall = myGoodsData.shoppingmall
                myGoods.pet = myGoodsData.pet
                afterOperation(context: context)
                print("succesive insert \(myGoodsData.productID)")
                return true
                }
        default:
            return false
        }
    }

    // MARK: - Fetch Methodes
    /**
     MyGoods의 모든 데이터를 오름차순으로 가져온다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
        - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 데이터를 가져오기 위한 파마리터.
            기본값은 nil로, 값을 넣어주지 않으면 고양이와 강아지의 모든 데이터를 가져온다.
     */
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

        if let pet = pet {
            let predicate = NSPredicate(format: "pet = %@", pet)
            request.predicate = predicate
        }

        request.sortDescriptors = [sort]

        let objects = try context.fetch(request)
        print("All fetch count: \(objects.count)")
        if !objects.isEmpty {
            for object in objects {
                var myGoodsData = MyGoodsData()
                myGoodsData.date = object.date
                myGoodsData.image = object.image
                myGoodsData.isFavorite = object.isFavorite
                myGoodsData.isLatest = object.isLatest
                myGoodsData.link = object.link
                myGoodsData.objectID = object.objectID
                myGoodsData.price = object.price
                myGoodsData.productID = object.productId
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

    /**
     해당펫의 즐겨찾기 한 데이터를 오름차순으로 가져온다
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
        - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 데이터를 가져오기 위한 파마리터.
     */
    func fetchFavoriteGoods(pet: String) throws -> [MyGoodsData]? {
        guard let context = context else {
            return nil
        }
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

        if !objects.isEmpty {
            for object in objects {
                var myGoodsData = MyGoodsData()
                myGoodsData.date = object.date
                myGoodsData.image = object.image
                myGoodsData.isFavorite = object.isFavorite
                myGoodsData.isLatest = object.isLatest
                myGoodsData.link = object.link
                myGoodsData.objectID = object.objectID
                myGoodsData.price = object.price
                myGoodsData.productID = object.productId
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

    /**
     해당펫의 최근본 상품을 오름차순으로 가져온다
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 데이터를 가져오기 위한 파마리터.
     - isLatest: 데이터를 오름차순, 또는 내림차순으로 가져오기 위한 파라미터
     */
    func fetchLatestGoods(pet: String, isLatest: Bool, isLatestOrder: Bool) throws -> [MyGoodsData]? {
        guard let context = context else {
            return nil
        }
        let sort = NSSortDescriptor(key: #keyPath(MyGoods.date), ascending: isLatestOrder)
        let predicate = NSPredicate(format: "pet = %@ AND isLatest = %@", pet, NSNumber(booleanLiteral: isLatest))
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

        if !objects.isEmpty {
            for object in objects {
                var myGoodsData = MyGoodsData()
                myGoodsData.date = object.date
                myGoodsData.image = object.image
                myGoodsData.isFavorite = object.isFavorite
                myGoodsData.isLatest = object.isLatest
                myGoodsData.link = object.link
                myGoodsData.objectID = object.objectID
                myGoodsData.price = object.price
                myGoodsData.productID = object.productId
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

    /**
     productId를 통해 동일한 상품이 Entity에 존재하는 지 확인.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
        - productId: 상품들마다 가지고 있는 고유 productId.
     */
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
    /**
     파라미터로 넣은 구조체와 동일한 개체의 모든 내용을 업데이트한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
        - coreDataStructType: coreDataStructType 프로토콜을 채택하는 CoreData Struct
     */
   @discardableResult func updateObject<T>(_ coreDataStructType: T) throws -> Bool {
        switch coreDataStructType {
        case is MyGoodsData:
            guard let context = context else {
                return  false
            }
            guard let myGoodsData = coreDataStructType as? MyGoodsData else {
                return false
            }
            guard let objectID = myGoodsData.objectID else {
                throw CoreDataError.update(message: "Can not find data, So can not update")
            }
            guard let object = context.object(with: objectID) as? MyGoods
                else { throw CoreDataError.update(message: "Can not find data, So can not update")
            }
            guard let date = myGoodsData.date else {
                return false
            }
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
            print("Product: \(myGoodsData.productID) update Complete")
            afterOperation(context: context)
            return true
        default:
            return false
        }
    }

    // MARK: - Delete Method
    /**
     파라미터로 넣은 구조체와 동일한 데이터를 삭제한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - coreDataStructType: coreDataStructType 프로토콜을 채택하는 CoreData Struct
     */
    @discardableResult func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        switch coreDataStructType {
        case is MyGoodsData:
            guard let context = context else {
                return false
            }
            guard let object = coreDataStructType as? MyGoodsData else { return false }
            if let objectID = object.objectID {
                let deleteObjet = context.object(with: objectID)
                context.delete(deleteObjet)
                afterOperation(context: context)
                return true
            }
        default:
            return false
        }
        return false
    }

    /**
     특정펫의 즐겨찾기한 상품들을 모두 삭제한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameters:
        - pet: 특정 펫의 데이터를 지우기위한 파라미터.
     */
    @discardableResult func deleteFavoriteAllObjects(pet: String) throws -> Bool {
        guard let context = context else {
            return false
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyGoods")
        let predicate = NSPredicate(format: "pet = %@ AND isFavorite = true AND isLatest = false", pet)

        fetchRequest.predicate = predicate
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            return true
        } catch {
            throw CoreDataError.delete(message: "Can't delete data")
        }
    }

    /**
     특정펫의 최근본 상품들을 모두 삭제한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameters:
     - pet: 특정 펫의 데이터를 지우기위한 파라미터.
     */
    @discardableResult func deleteLatestAllObjects(pet: String, isLatest: Bool) throws -> Bool {
        guard let context = context else {
            return false
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyGoods")
        let predicate = NSPredicate(format: "pet = %@ AND isLatest = %@ AND isFavorite = false", pet, NSNumber(booleanLiteral: isLatest))
        fetchRequest.predicate = predicate
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            return true
        } catch {
            throw CoreDataError.delete(message: "Can't delete data")
        }
    }

    /**
     최근본 상품들을 날짜순으로 정렬 후 10개를 제외한 데이터들은 최근본 정보를 false로 변환
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameters:
        - pet: 특정 펫의 데이터를 지우기위한 파라미터.
     */
    func latestGoodsToFalse(pet: String) throws {
        do {
            guard var objects = try fetchLatestGoods(pet: pet, isLatest: true, isLatestOrder: false) else {
                throw CoreDataError.fetch(message: "Can not fetch data")
            }
            if objects.count > 10 {
                for index in 10..<objects.count {
                    objects[index].isLatest = false
                    print(index)
                    try updateObject(objects[index])
                }
            }
        } catch let error as NSError {
            throw CoreDataError.fetch(message: "Can not fetch data: \(error)")
        }
    }
}

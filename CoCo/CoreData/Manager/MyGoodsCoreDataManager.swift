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

struct MyGoodsCoreDataManager: MyGoodsCoreDataManagerType, CoreDataManagerFunctionImplementType {
    // MARK: - Property
    var commonCoreDataManagerType: CommonCoreDataManagerType
    // MARK: - Initialize
    init(commonCoreDataManagerType: CommonCoreDataManagerType) {
        self.commonCoreDataManagerType = commonCoreDataManagerType
    }
    // MARK: - Fetch Methodes
    /**
     MyGoods의 모든 데이터를 오름차순으로 가져온다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 데이터를 가져오기 위한 파마리터.
     기본값은 nil로, 값을 넣어주지 않으면 고양이와 강아지의 모든 데이터를 가져온다.
     */
    func fetchObjects(pet: String? = nil, completion: @escaping ([CoreDataStructEntity]?, Error?) -> Void) {
        guard let container = container else {
            return
        }
        container.performBackgroundTask { (context) in
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

            do {
                let objects = try context.fetch(request)
                if !objects.isEmpty {
                    for object in objects {
                        var myGoodsData = MyGoodsData()
                        myGoodsData.mappinng(from: object)
                        myGoodsDatas.append(myGoodsData)
                    }
                    completion(myGoodsDatas, nil)
                } else {
                    completion(nil, nil)
                }
            } catch let error {
                completion(nil, error)
            }
        }
    }

    /**
     해당펫의 즐겨찾기 한 데이터를 오름차순으로 가져온다
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 데이터를 가져오기 위한 파마리터.
     */
    func fetchFavoriteGoods(pet: String? = nil, completion: @escaping ([MyGoodsData]?, Error?) -> Void) {
        guard let container = container else {
            return
        }
        container.performBackgroundTask { (context) in
            let request: NSFetchRequest<MyGoods>
            let sort = NSSortDescriptor(key: #keyPath(MyGoods.date), ascending: true)
            var myGoodsDatas: [MyGoodsData] = []

            if #available(iOS 10.0, *) {
                let tmpRequest: NSFetchRequest<MyGoods> = MyGoods.fetchRequest()
                request = tmpRequest
            } else {
                let entityName = String(describing: MyGoods.self)
                request = NSFetchRequest(entityName: entityName)
            }

            let predicate: NSPredicate
            if let pet = pet {
                predicate = NSPredicate(format: "pet = %@ AND isFavorite = %@", pet, NSNumber(booleanLiteral: true))
            } else {
                predicate = NSPredicate(format: "isFavorite = %@", NSNumber(booleanLiteral: true))
            }
            request.predicate = predicate

            request.sortDescriptors = [sort]

            do {
                let objects = try context.fetch(request)
                if !objects.isEmpty {
                    for object in objects {
                        var myGoodsData = MyGoodsData()
                        myGoodsData.mappinng(from: object)
                        myGoodsDatas.append(myGoodsData)
                    }
                    completion(myGoodsDatas, nil)
                } else {
                    completion(nil, nil)
                }
            } catch let error {
                completion(nil, error)
            }
        }
    }

    /**
     해당펫의 최근본 상품을 오름차순, 내림차순으로 가져온다
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 데이터를 가져오기 위한 파마리터.
     - isLatest: 데이터를 오름차순, 또는 내림차순으로 가져오기 위한 파라미터
     */
    func fetchLatestGoods(pet: String? = nil, isLatest: Bool, ascending: Bool, completion: @escaping ([MyGoodsData]?, Error?) -> Void) {
        guard let container = container else {
            return
        }
        container.performBackgroundTask { (context) in
            let sort = NSSortDescriptor(key: #keyPath(MyGoods.date), ascending: ascending)
            var myGoodsDatas: [MyGoodsData] = []
            let request: NSFetchRequest<MyGoods>
            let predicate: NSPredicate
            if #available(iOS 10.0, *) {
                let tmpRequest: NSFetchRequest<MyGoods> = MyGoods.fetchRequest()
                request = tmpRequest
            } else {
                let entityName = String(describing: MyGoods.self)
                request = NSFetchRequest(entityName: entityName)
            }
            if let pet = pet {
                predicate = NSPredicate(format: "pet = %@ AND isLatest = %@", pet, NSNumber(booleanLiteral: isLatest))
            } else {
                predicate = NSPredicate(format: "isLatest = %@", NSNumber(booleanLiteral: isLatest))
            }

            request.returnsObjectsAsFaults = false
            request.predicate = predicate
            request.sortDescriptors = [sort]

            do {
                let objects = try context.fetch(request)
                if !objects.isEmpty {
                    for object in objects {
                        var myGoodsData = MyGoodsData()
                        myGoodsData.mappinng(from: object)
                        myGoodsDatas.append(myGoodsData)
                    }
                    completion(myGoodsDatas, nil)
                } else {
                    completion(nil, nil)
                }
            } catch let error {
                completion(nil, error)
            }
        }
    }

    /**
     productId를 통해 동일한 상품이 Entity에 존재하는 지 확인.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - productId: 상품들마다 가지고 있는 고유 productId.
     */
    func fetchProductID(productID: String, completion: @escaping (MyGoods?, Error?) -> Void) {
        guard let container = container else {
            return
        }
        container.performBackgroundTask { (context) in
            let request: NSFetchRequest<MyGoods>

            if #available(iOS 10.0, *) {
                let tmpRequest: NSFetchRequest<MyGoods> = MyGoods.fetchRequest()
                request = tmpRequest
            } else {
                let entityName = String(describing: MyGoods.self)
                request = NSFetchRequest(entityName: entityName)
            }

            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "productID = %@", productID)

            do {
                let object = try context.fetch(request)
                guard let firstObject = object.first else {
                    return
                }
                completion(firstObject, nil)
            } catch let error as NSError {
                completion(nil, error)
            }
        }
    }

    // MARK: - Delete Method
    /**
     특정펫의 즐겨찾기한 상품들을 모두 삭제한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameters:
     - pet: 특정 펫의 데이터를 지우기위한 파라미터.
     */
    func deleteFavoriteAllObjects(pet: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let container = container else {
            return
        }
        container.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyGoods")
            let predicate = NSPredicate(format: "pet = %@ AND isFavorite = true AND isLatest = false", pet)

            fetchRequest.predicate = predicate
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(batchDeleteRequest)
                completion(true, nil)
            } catch let error {
                completion(false, error)
            }
        }
    }

    /**
     특정펫의 최근본 상품들을 모두 삭제한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameters:
     - pet: 특정 펫의 데이터를 지우기위한 파라미터.
     */
    func deleteLatestAllObjects(pet: String, isLatest: Bool, completion: @escaping (Bool, Error?) -> Void) {
        guard let container = container else {
            return
        }
        container.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyGoods")
            let predicate = NSPredicate(format: "pet = %@ AND isLatest = %@ AND isFavorite = false", pet, NSNumber(booleanLiteral: isLatest))
            fetchRequest.predicate = predicate
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(batchDeleteRequest)
                completion(true, nil)
            } catch let error {
                completion(false, error)
            }
        }
    }

    /**
     최근본 상품들을 날짜순으로 정렬 후 10개를 제외한 데이터들은 최근본 정보를 false로 변환
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameters:
     - pet: 특정 펫의 데이터를 지우기위한 파라미터.
     */
    func latestGoodsToFalse(pet: String, completion: @escaping (Error?) -> Void) {
        fetchLatestGoods(pet: pet, isLatest: true, ascending: false) { (myGoodsData, _) in
            guard var myGoodsData = myGoodsData else {
                return
            }
            if myGoodsData.count > 10 {
                for index in 10..<myGoodsData.count {
                    myGoodsData[index].isLatest = false
                    self.commonCoreDataManagerType.updateObject(myGoodsData[index]) { (isSuccess) in
                        if isSuccess {
                            completion(nil)
                        }
                    }
                }
            }
            completion(nil)
        }
    }
}

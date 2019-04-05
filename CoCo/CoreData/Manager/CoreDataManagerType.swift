//
//  CoreDataManager.swift
//  CoCo
//
//  Created by 강준영 on 28/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import CoreData
import UIKit

// MARK: - CoreDataManagerType
protocol CoreDataManagerType {
    // MARK: - Property
    var container: NSPersistentContainer? { get }
    // MARK: Methodes
    func afterOperation(context: NSManagedObjectContext?)
    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T, completion:@escaping (Bool, Error?) -> Void)
    func fetchObjects<T: NSManagedObject>(_ entityClass: T.Type, sortBy: [NSSortDescriptor]?, predicate: NSPredicate?, completion: @escaping ([T]?, Error?) -> Void)
    func updateObject<T: CoreDataStructEntity>(_ coreDataStructType: T, completion:@escaping (Bool) -> Void)
    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T, completion: @escaping (Bool) -> Void)
}

// MARK: - MyGoodsCoreDataManagerType
protocol MyGoodsCoreDataManagerType: CoreDataManagerType {
    // MARK: - Methodes
    func fetchObjects(pet: String?, completion:@escaping ([CoreDataStructEntity]?, Error?) -> Void)
    func fetchFavoriteGoods(pet: String?, completion: @escaping ([MyGoodsData]?, Error?) -> Void)
    func fetchLatestGoods(pet: String?, isLatest: Bool, ascending: Bool, completion: @escaping ([MyGoodsData]?, Error?) -> Void)
    func fetchProductID(productID: String, completion: @escaping (MyGoods?, Error?) -> Void)
    func deleteFavoriteAllObjects(pet: String, completion: @escaping (Bool, Error?) -> Void)
    func deleteLatestAllObjects(pet: String, isLatest: Bool, completion: @escaping (Bool, Error?) -> Void)
}

// MARK: - PetKeywordCoreDataManagerType
protocol PetKeywordCoreDataManagerType: CoreDataManagerType {
    // MARK: - Methodes
    func fetchObjects(pet: String?, completion:@escaping ([CoreDataStructEntity]?, Error?) -> Void)
    func fetchOnlyKeyword(pet: String, completion: @escaping (([String]?, Error?) -> Void))
    func fetchOnlyPet(completion: @escaping (String?, Error?) -> Void)
    func deleteAllObjects(pet: String, completion: @escaping (Bool, Error?) -> Void)
}

// MARK: - SearchWordCoreDataManagerType
protocol SearchWordCoreDataManagerType: CoreDataManagerType {
    // MARK: - Methodes// MARK: - Methodes
    func fetchObjects(pet: String?, completion:@escaping ([CoreDataStructEntity]?, Error?) -> Void)
    func fetchOnlySearchWord(pet: String, completion: @escaping (([String]?, Error?) -> Void))
    func fetchWord(_ searchWord: String, pet: String, completion: @escaping (SearchWordData?, Error?) -> Void)
    func deleteAllObjects(pet: String, completion: @escaping (Bool, Error?) -> Void)
}

extension CoreDataManagerType {
    var container: NSPersistentContainer? {
        let container =  CoreDataStack.shared.persistentContainer
        return container
    }
    // MARK: - Util Method
    /**
     코어데이터 연산 후 데이터들이 반영되거나 수정되기전 상태로 돌아가게 하는 메서드
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - context: managedObject를 create, fetch, save할 때 사용되는 객체
     */
    func afterOperation(context: NSManagedObjectContext?) {
        guard let context = context else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
}

extension CoreDataManagerType {
    // MARK: - Insert Method
    /**
     MyGoods Entity에 데이터 삽입.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - coreDataStructType: coreDataStructType 프로토콜을 채택하는 CoreData Struct.
     */
    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T, completion: @escaping (Bool, Error?) -> Void) {
        print("interttrtrtrtrtrtrtrtr")
        guard let container = container else {
            return
        }
        switch coreDataStructType {
        case is MyGoodsData:
            guard var myGoodsData = coreDataStructType as? MyGoodsData else {
                return
            }
            // 삽입하려는 데이터와 동일한 productID가 존재하면 기존 데이터 업데이트
            MyGoodsCoreDataManager().fetchProductID(productID: myGoodsData.productID) { (fetchResult, error) in
                if let error = error {
                    completion(false, error)
                }
                if let object = fetchResult {
                    myGoodsData.objectID = object.objectID
                    self.updateObject(myGoodsData) { (isSuccess) in
                        if isSuccess {
                            completion(true, nil)
                        }
                    }
                // 삽입하려는 데이터와 동일한 데이터가 MyGoods Entity에 존재하는 지 확인하기 위해 삽입하려는 데이터의 productID를 Entity에 존재하는 지 확인.
                // 삽입하려는 데이터의 productID와 동일한 데이터가 없는 경우 삽입을 진행
                } else {
                    container.performBackgroundTask { (context) in
                        let myGoods = MyGoods(context: context)
                        myGoodsData.mappinng(to: myGoods)
                        self.afterOperation(context: context)
                        completion(true, nil)
                    }
                }
            }
        case is PetKeywordData:
            guard var petKeywordData = coreDataStructType as? PetKeywordData else {
                return
            }
            // PetKeyword Entity는 동물별로 데이터가 하나만 존재해야하기 때문에 데이터가 존재하는 지 확인
            PetKeywordCoreDataManager().fetchObjects(pet: petKeywordData.pet) { (fetchResult, error) in
                if let error = error {
                    completion(false, error)
                }
                if let objects = fetchResult {
                    if var object = objects.first {
                        petKeywordData.objectID = object.objectID
                        self.updateObject(petKeywordData) { (_) in
                            completion(true, nil)
                        }
                    }
                } else {
                    container.performBackgroundTask { (context) in
                        let petKeyword = PetKeyword(context: context)
                        petKeywordData.mappinng(to: petKeyword)
                        self.afterOperation(context: context)
                        completion(true, nil)
                    }
                }
            }
        case is SearchWordData:
            guard var searchKeywordData = coreDataStructType as? SearchWordData else {
                return
            }
            guard let pet = searchKeywordData.pet else {
                return
            }
            // SearchKeyword Entity에 검색에가 존재하는 지 확인
            // 검색어가 존재하면 업데이트
            SearchWordCoreDataManager().fetchWord(searchKeywordData.searchWord, pet: pet) { (fetchResult, error) in
                if let error = error {
                    completion(false, error)
                }
                if let object = fetchResult {
                searchKeywordData.objectID = object.objectID
                self.updateObject(searchKeywordData) { (isSuccess) in
                    if isSuccess {
                        completion(true, nil)
                    }
                }
                // 존재하지 않으면 검색어 데이터 추가
                } else {
                    container.performBackgroundTask { (context) in
                        let searchKeyword = SearchWord(context: context)
                        searchKeywordData.mappinng(to: searchKeyword)
                        self.afterOperation(context: context)
                        completion(true, nil)
                    }
                }
            }
        default:
            completion(false, nil)
        }
    }
}

extension CoreDataManagerType {
    func fetchObjects<T: NSManagedObject>(_ entityClass: T.Type, sortBy: [NSSortDescriptor]?, predicate: NSPredicate?, completion: @escaping([T]?, Error?) -> Void) {
        print("Fetchchchchchchchchc")
        guard let container = container else {
            return
        }
        container.performBackgroundTask { (context) in
            let request: NSFetchRequest<T>
            if #available(iOS 10.0, *) {
                guard let tmpRequest = entityClass.fetchRequest() as? NSFetchRequest<T> else {
                    return
                }
                request = tmpRequest
            } else {
                let entityName = String(describing: entityClass)
                request = NSFetchRequest(entityName: entityName)
            }
            request.predicate = predicate
            request.sortDescriptors = sortBy

            do {
                let fetchedResult = try context.fetch(request)
                completion(fetchedResult, nil)
            } catch let error {
                print(error)
                completion(nil, error)
            }

        }
    }
}

extension CoreDataManagerType {
    // MARK: - Update Method
    /**
     파라미터로 넣은 구조체와 동일한 개체의 모든 내용을 업데이트한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter:
     - coreDataStructType: coreDataStructType 프로토콜을 채택하는 CoreData Struct
     */
    func updateObject<T>(_ coreDataStructType: T, completion:@escaping (Bool) -> Void) {
        print("Updatetetetetetet")
        guard let container = container else {
            return
        }
        switch coreDataStructType {
        case is MyGoodsData:
            container.performBackgroundTask { (context) in
                guard let myGoodsData = coreDataStructType as? MyGoodsData else {
                    return
                }
                guard let objectID = myGoodsData.objectID else {
                    return
                }
                guard let object = context.object(with: objectID) as? MyGoods
                    else {
                        return
                }
                myGoodsData.mappinng(to: object)
                self.afterOperation(context: context)
                completion(true)
            }
        case is PetKeywordData:
            container.performBackgroundTask { (context) in
                guard let petKeywordData = coreDataStructType as? PetKeywordData else {
                    return
                }
                guard let objectID = petKeywordData.objectID else {
                    return
                }
                guard let object = context.object(with: objectID) as? PetKeyword else {
                    return
                }
                petKeywordData.mappinng(to: object)
                self.afterOperation(context: context)
                completion(true)
            }
        case is SearchWordData:
            container.performBackgroundTask { (context) in
                guard let searchWordData = coreDataStructType as? SearchWordData else {
                    return
                }
                guard let objectID = searchWordData.objectID else {
                    return
                }
                guard let object = context.object(with: objectID) as? SearchWord else {
                    return
                }
                searchWordData.mappinng(to: object)
                self.afterOperation(context: context)
                completion(true)
            }
        default:
            completion(false)
        }
    }
}

extension CoreDataManagerType {
    // MARK: - Delete Method
    /**
     파라미터로 넣은 구조체와 동일한 데이터를 삭제한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - coreDataStructType: coreDataStructType 프로토콜을 채택하는 CoreData Struct
     */
    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T, completion: @escaping (Bool) -> Void) {
        guard let container = container else {
            return
        }
        switch coreDataStructType {
        case is MyGoodsData:
            container.performBackgroundTask { (context) in
                guard let object = coreDataStructType as? MyGoodsData else {
                    return
                }
                if let objectID = object.objectID {
                    let deleteObjet = context.object(with: objectID)
                    context.delete(deleteObjet)
                    self.afterOperation(context: context)
                    completion(true)
                }
            }
        case is PetKeywordData:
            container.performBackgroundTask { (context) in
                guard let petKeywordData = coreDataStructType as? PetKeywordData else {
                    return
                }
                if let objectID = petKeywordData.objectID {
                    let object = context.object(with: objectID)
                    context.delete(object)
                    self.afterOperation(context: context)
                    completion(true)
                }
            }
        case is SearchWordData:
            container.performBackgroundTask { (context) in
                guard let searchKeywordData = coreDataStructType as? SearchWordData else {
                    return
                }
                if let objectID = searchKeywordData.objectID {
                    let object = context.object(with: objectID)
                    context.delete(object)
                    self.afterOperation(context: context)
                    completion(true)
                }
            }

        default:
            completion(false)
        }
    }
}

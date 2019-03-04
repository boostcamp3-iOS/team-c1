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
    var context: NSManagedObjectContext? { get }
    // MARK: Methodes
    func afterOperation(context: NSManagedObjectContext?)
    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool
    func fetchObjects(pet: String?) throws -> [CoreDataStructEntity]?
    func updateObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool
    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool
}

// MARK: - MyGoodsCoreDataManagerType
protocol MyGoodsCoreDataManagerType: CoreDataManagerType {
    // MARK: - Methodes
    func fetchFavoriteGoods(pet: String?) throws -> [MyGoodsData]?
    func fetchLatestGoods(pet: String?, isLatest: Bool, ascending: Bool) throws -> [MyGoodsData]?
    func fetchProductID(productID: String) -> MyGoods?
    func deleteFavoriteAllObjects(pet: String) throws -> Bool
    func deleteLatestAllObjects(pet: String, isLatest: Bool) throws -> Bool
}

// MARK: - PetKeywordCoreDataManagerType
protocol PetKeywordCoreDataManagerType: CoreDataManagerType {
    // MARK: - Methodes
    func fetchOnlyKeyword(pet: String) throws -> [String]?
    func fetchOnlyPet() throws -> String?
    func deleteAllObjects(pet: String) throws -> Bool
}

// MARK: - SearchWordCoreDataManagerType
protocol SearchWordCoreDataManagerType: CoreDataManagerType {
    // MARK: - Methodes// MARK: - Methodes
    func fetchOnlySearchWord(pet: String) throws -> [String]?
    func updateObject(searchWord: String, pet: String) throws -> Bool
    func deleteAllObjects(pet: String) throws -> Bool
}

extension CoreDataManagerType {
    var context: NSManagedObjectContext? {
        return CoreDataStack.shared.persistentContainer.viewContext
    }
    // MARK: - Insert Method
    /**
     MyGoods Entity에 데이터 삽입.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - coreDataStructType: coreDataStructType 프로토콜을 채택하는 CoreData Struct.
     */
    @discardableResult func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        guard let context = context else {
            return false
        }
        switch coreDataStructType {
        case is MyGoodsData:
            guard var myGoodsData = coreDataStructType as? MyGoodsData else {
                return false
            }
            // 삽입하려는 데이터와 동일한 productID가 존재하면 기존 데이터 업데이트
            if let object = MyGoodsCoreDataManager().fetchProductID(productID: myGoodsData.productID) {
                myGoodsData.objectID = object.objectID
                try updateObject(myGoodsData)
                return true
                // 삽입하려는 데이터와 동일한 데이터가 MyGoods Entity에 존재하는 지 확인하기 위해 삽입하려는 데이터의 productID를 Entity에 존재하는 지 확인.
                // 삽입하려는 데이터의 productID와 동일한 데이터가 없는 경우 삽입을 진행
            } else {
                let myGoods = MyGoods(context: context)
                myGoodsData.mappinng(to: myGoods)
                print(myGoods)
                afterOperation(context: context)
                return true
            }
        case is PetKeywordData:
            guard var petKeywordData = coreDataStructType as? PetKeywordData else {
                return false
            }
            do {
                // PetKeyword Entity는 동물별로 데이터가 하나만 존재해야하기 때문에 데이터가 존재하는 지 확인
                if let objects = try PetKeywordCoreDataManager().fetchObjects(pet: petKeywordData.pet) {
                    if var object = objects.first {
                        petKeywordData.objectID = object.objectID
                        try updateObject(petKeywordData)
                    }
                    // 존재하지 않는 경우 데이터 삽입
                } else {
                    let petKeyword = PetKeyword(context: context)
                    petKeywordData.mappinng(to: petKeyword)
                    afterOperation(context: context)
                }
                return true
            } catch let error as NSError {
                throw CoreDataError.insert(message: "Can't insert data : \(error)")
            }
        case is SearchWordData:
            guard var searchKeywordData = coreDataStructType as? SearchWordData else {
                return false
            }
            guard let pet = searchKeywordData.pet else {
                return false
            }
            do {
                // SearchKeyword Entity에 검색에가 존재하는 지 확인
                // 검색어가 존재하면 업데이트
                if let object = try SearchWordCoreDataManager().fetchWord(searchKeywordData.searchWord, pet: pet) {
                    searchKeywordData.objectID = object.objectID
                    try updateObject(searchKeywordData)
                    // 존재하지 않으면 검색어 데이터 추가
                } else {
                    let searchKeyword = SearchWord(context: context)
                    searchKeywordData.mappinng(to: searchKeyword)
                    afterOperation(context: context)
                }
                return true
            } catch let error as NSError {
                throw CoreDataError.update(message: "Can't not Insert \(error)")
            }
        default:
            return false
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
    @discardableResult func updateObject<T>(_ coreDataStructType: T) throws -> Bool {
        guard let context = context else {
            return  false
        }
        switch coreDataStructType {
        case is MyGoodsData:
            guard let myGoodsData = coreDataStructType as? MyGoodsData else {
                return false
            }
            guard let objectID = myGoodsData.objectID else {
                throw CoreDataError.update(message: "Can not find data, So can not update")
            }
            guard let object = context.object(with: objectID) as? MyGoods
                else { throw CoreDataError.update(message: "Can not find data, So can not update")
            }
            myGoodsData.mappinng(to: object)
            afterOperation(context: context)
            return true
        case is PetKeywordData:
            guard let petKeywordData = coreDataStructType as? PetKeywordData else {
                return false
            }
            guard let objectID = petKeywordData.objectID else {
                throw CoreDataError.update(message: "Can not find this data(\(petKeywordData)), So can not update")
            }
            guard let object = context.object(with: objectID) as? PetKeyword else {
                return false
            }
            petKeywordData.mappinng(to: object)
            afterOperation(context: context)
            return true
        case is SearchWordData:
            guard let searchWordData = coreDataStructType as? SearchWordData else {
                return false
            }
            guard let objectID = searchWordData.objectID else { throw CoreDataError.update(message: "Can not find this data(\(searchWordData)), So can not update")}
            guard let object = context.object(with: objectID) as? SearchWord else {
                return false
            }
            searchWordData.mappinng(to: object)
            afterOperation(context: context)
            return true
        default:
            return false
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
    @discardableResult func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        guard let context = context else {
            return false
        }
        switch coreDataStructType {
        case is MyGoodsData:
            guard let object = coreDataStructType as? MyGoodsData else { return false }
            if let objectID = object.objectID {
                let deleteObjet = context.object(with: objectID)
                context.delete(deleteObjet)
                afterOperation(context: context)
                return true
            }
        case is PetKeywordData:
            guard let petKeywordData = coreDataStructType as? PetKeywordData else {
                return false
            }
            if let objectID = petKeywordData.objectID {
                let object = context.object(with: objectID)
                context.delete(object)
                afterOperation(context: context)
                return true
            }
        case is SearchWordData:
            guard let searchKeywordData = coreDataStructType as? SearchWordData else {
                return false
            }
            if let objectID = searchKeywordData.objectID {
                let object = context.object(with: objectID)
                context.delete(object)
                afterOperation(context: context)
                return true
            }
        default:
            return false
        }
        return false
    }
}

extension CoreDataManagerType {
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

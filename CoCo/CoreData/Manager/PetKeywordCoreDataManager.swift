//
//  PetKeywordDAO.swift
//  CoCo
//
//  Created by 강준영 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

class PetKeywordCoreDataManager: PetKeywordCoreDataManagerType, CoreDataManagerFunctionImplementType {
    // MARK: - Insert Method
    /**
     PetKeyword Entity에 데이터 삽입.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - coreDataStructType: coreDataStructType 프로토콜을 채택하는 CoreData Struct.
     */
    @discardableResult func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        switch coreDataStructType {
        case is PetKeywordData:
            guard let context = context else { return false }
            guard let petKeywordData = coreDataStructType as? PetKeywordData else {
                return false
            }

            do {
                // PetKeyword Entity는 동물별로 데이터가 하나만 존재해야하기 때문에 데이터가 존재하는 지 확인
                guard let objects = try fetchObjects(pet: petKeywordData.pet) else { return false }
                // 데이터가 존재하는 경우 데이터 삭제 후 추가 : 펫별로 데이터는 항상 하나만 존재해야 하기 때문
                if !objects.isEmpty {
                    if let first = objects.first {
                        guard let objectID = first.objectID else { return false }
                        let object = context.object(with: objectID)
                        context.delete(object)
                        let petKeyword = PetKeyword(context: context)
                        petKeyword.keywords = petKeywordData.keywords as NSObject
                        petKeyword.pet = petKeywordData.pet
                        afterOperation(context: context)
                        print("Already Pet and Keyword inserted, So Update")
                        print("Update Successive => \(petKeyword)")
                    }
                // 존재하지 않는 경우 데이터 삽입
                } else {
                    let petKeyword = PetKeyword(context: context)
                    petKeyword.keywords = petKeywordData.keywords as NSObject
                    petKeyword.pet = petKeywordData.pet
                    afterOperation(context: context)
                    print("Insert Successive => \(petKeyword)")
                }
                return true
            } catch let error as NSError {
                throw CoreDataError.fetch(message: "Can't fetch data .: \(error)")
            }
        default:
             return false
        }
    }

    // MARK: - Fetch Methodes
    /**
     PetKeyword의 모든 데이터를 오름차순으로 가져옴
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
        - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 데이터를 가져오기 위한 파마리터.
        기본값은 nil로, 값을 넣어주지 않으면 고양이와 강아지의 모든 데이터를 가져온다.
     */
    // 데이터 타입(Keyword, Pet)변경해서 리턴
    func fetchObjects(pet: String? = nil) throws -> [CoreDataStructEntity]? {
        guard let context = context else { return nil }
        var petKeywordDatas = [PetKeywordData]()
        let request: NSFetchRequest<PetKeyword>
        
        if #available(iOS 10.0, *) {
            let tmpRequest: NSFetchRequest<PetKeyword> = PetKeyword.fetchRequest()
            request = tmpRequest
        } else {
            let entityName = String(describing: PetKeyword.self)
            request = NSFetchRequest(entityName: entityName)
        }
        
        if let pet = pet {
            let predicate = NSPredicate(format: "pet = %@", pet)
            request.predicate = predicate
        }
        request.returnsObjectsAsFaults = false
        let objects = try context.fetch(request)
        
        if !objects.isEmpty {
            for object in objects {
                var petKeyword = PetKeywordData()
                guard let keywords = object.keywords as? [String] else {
                    return nil
                }
                petKeyword.objectID = object.objectID
                petKeyword.pet = object.pet
                petKeyword.keywords = keywords
                petKeywordDatas.append(petKeyword)
            }
            return petKeywordDatas
        } else {
            throw CoreDataError.fetch(message: "PetKeyword Entity has not data, So can not fetch data")
        }
    }

    // Fetch Only Keyword Data
    /**
     특정펫의 키워드를 모두 가져온다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 키워드를 가져오기 위한 파마리터.
     */
    func fetchOnlyKeyword(pet: String) throws -> [String]? {
        var keywords = [String]()
        do {
            guard let objects = try fetchObjects(pet: pet) else {
                throw CoreDataError.fetch(message: "PetKeyword Entity has not  data, So can not fetch data")
            }
            guard let petKeywordDatas = objects as? [PetKeywordData] else { return nil }
            guard let petKeywordData = petKeywordDatas.first else { return nil }
            keywords = petKeywordData.keywords
            return keywords
        } catch let error as NSError {
            throw CoreDataError.fetch(message: "Can not fetch data \(error)")
        }
    }

    // Fetch Only Pet
    /**
     특정펫의 펫정보만을 가져온다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
        - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 펫정보를 가져오기 위한 파마리터.
     */
    func fetchOnlyPet(pet: String) throws -> String? {
        do {
            guard let objects = try fetchObjects(pet: pet) else {
                throw CoreDataError.fetch(message: "PetKeyword Entity has not  data, So can not fetch data")
            }
            guard let petKeywordDatas = objects as? [PetKeywordData] else { return nil }
            guard let petKeywordData = petKeywordDatas.first else { return nil }
            return petKeywordData.pet
        } catch let error as NSError {
            throw CoreDataError.fetch(message: "Can not fetch data \(error)")
        }
    }

    // MARK: - Update Method
    /**
     파라미터로 넣은 구조체와 동일한 개체의 모든 내용을 업데이트한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
        - coreDataStructType: coreDataStructType 프로토콜을 채택하는 CoreData Struct
     */
    @discardableResult func updateObject<T>(_ coreDataStructType: T) throws -> Bool where T : CoreDataStructEntity {
        switch coreDataStructType {
        case is PetKeywordData:
            guard let context = context else { return false }
            guard let petKeywordData = coreDataStructType as? PetKeywordData else { return false }
            guard let objectID = petKeywordData.objectID else {
                throw CoreDataError.update(message: "Can not find this data(\(petKeywordData)), So can not update")
            }
            guard let object = context.object(with: objectID) as? PetKeyword else {
                return false
            }
            object.pet = petKeywordData.pet
            object.keywords = petKeywordData.keywords as NSObject
            afterOperation(context: context)
            print("Update Successive => \(object)")
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
    @discardableResult func deleteObject<T>(_ coreDataStructType: T) throws -> Bool where T : CoreDataStructEntity {
        switch coreDataStructType {
        case is PetKeywordData:
            guard let context = context else { return false }
            guard let petKeywordData = coreDataStructType as? PetKeywordData else {
                return false
            }
            if let objectID = petKeywordData.objectID {
                let object = context.object(with: objectID)
                context.delete(object)
                afterOperation(context: context)
                print("Delete Successive")
                return true
            }
        default:
            return false
        }
        return false
    }
    
    /**
     특정펫의 데이터를 삭제한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameters:
        - pet: 특정 펫의 데이터를 지우기위한 파라미터.
     */
    @discardableResult func deleteAllObjects(pet: String) throws -> Bool {
        guard let context = context else { return false }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PetKeyword")
        let predicate = NSPredicate(format: "pet = %@", pet)
        
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

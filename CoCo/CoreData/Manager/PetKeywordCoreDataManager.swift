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
    
    func fetch<T>(_ coreDataType: T.Type, sortBy: [NSSortDescriptor]?, predicate: NSPredicate?) throws -> [T]? where T : CoreDataEntity {
        return nil
    }
    
 
    // MARK: - Methodes
    // MARK: - Insert Method
    @discardableResult func insertCoreData<T>(_ coreDataType: T) throws -> Bool {
        guard let context = context else { return false }

        switch coreDataType {
        case is PetKeywordData:
            guard let petKeywordData = coreDataType as? PetKeywordData
                else {
                    return false
            }

            do {
                // PetKeyword Entity는 데이터가 하나만 존재해야하기 때문에 데이터가 존재하는 지 확인
                guard let objects = try fetchObjects(PetKeyword.self, sortBy: nil, predicate: nil) else { return false }
                // 데이터가 존재하는 경우 데이터 삭제 후 추가 : 데이터는 항상 하나만 존재해야 하기 때문

                if objects.count > 0 {
                    if let first = objects.first {
                        context.delete(first)
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
                print("\(error)")
            }
        default:
            break
        }
        return false
    }

    // MARK: - Fetch Methodes
    // Fetch All Data - PetKeyword의 모든 데이터 정보를 가져옴
    func fetchPetKeyword() throws -> [PetKeywordData]? {
        var petKeywordDatas = [PetKeywordData]()

        do {
            guard let objects = try fetchObjects(PetKeyword.self, sortBy: nil, predicate: nil) else {
            throw CoreDataError.fetch(message: "PetKeyword Entity has not data, So can not fetch data")
            }
            for object in objects {
                guard let keywords = object.keywords as? [String] else {
                    return nil
                }
                var petKeywordData = PetKeywordData()
                petKeywordData.pet = object.pet
                petKeywordData.keywords = keywords
                petKeywordData.objectID = object.objectID
                petKeywordDatas.append(petKeywordData)
            }
            return petKeywordDatas
        } catch let  error as NSError {
            print("\(error)")
        }
        return nil
    }

    // Fetch Only Keyword Data
    func fetchOnlyKeyword() throws -> [String]? {
        var keywords = [String]()
        do {
            guard let objects = try fetchObjects(PetKeyword.self, sortBy: nil, predicate: nil) else {
                throw CoreDataError.fetch(message: "PetKeyword Entity has not  data, So can not fetch data")
            }
            for object in objects {
                guard let keyword = object.keywords as? [String] else {
                    return nil
                }
                keywords += keyword
            }
            return keywords
        } catch let error as NSError {
            print(error)
        }
        return nil
    }

    // Fetch Only Pet
    func fetchOnlyPet() throws -> [String]? {
        var pets = [String]()
        do {
            guard let objects = try fetchObjects(PetKeyword.self, sortBy: nil, predicate: nil) else {
                throw CoreDataError.fetch(message: "PetKeyword Entity has not  data, So can not fetch data")
            }
            for object in objects {
                pets.append(object.pet)
            }
            return pets
        } catch let error as NSError {
            print(error)
        }
        return nil
    }

    // MARK: - Update Method
    // Update PetKeyword Data
    @discardableResult func updatePetKeyword(_ petKeywordData: PetKeywordData) throws -> Bool {
        guard let context = context else { return false }
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
    }
    
    func updateObject<T>(_ coreDataType: T) throws -> Bool where T : CoreDataEntity {
        return false
    }
    

    // MARK: - Delete Method
    // Delete PetKeyword Data
    @discardableResult func delete(_ petKeywordData: PetKeywordData) throws -> Bool {
        guard let context = context else { return false }

        if let objectID = petKeywordData.objectID {
            let object = context.object(with: objectID)
            context.delete(object)
            afterOperation(context: context)
            print("Delete Successive")
            return true
        } else {
            throw CoreDataError.delete(message: "Can not find this data(\(petKeywordData)), So can not delete")
        }
    }
}

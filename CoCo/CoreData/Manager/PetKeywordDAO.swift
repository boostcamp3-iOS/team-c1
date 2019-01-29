//
//  PetKeywordDAO.swift
//  CoCo
//
//  Created by 강준영 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

class PetKeywordDAO: CoreDataManager {

    static let shared = PetKeywordDAO()

    func insertCoreData<T>(coreDataType: T) throws -> Bool where T: CoreDataEntity {
        guard let context = context else {
            return false
        }
        switch coreDataType {
        case is PetKeywordData:
            guard let petKeywordData = coreDataType as? PetKeywordData
                else {
                    return false
            }

            do {
                guard let objects = try fetchObjects(PetKeyword.self, sortBy: nil, predicate: nil) else {
                    return false
                }
                if objects.count > 0 {
                    print("Already Pet and Keyword inserted")
                    // TODO: 존재하면 업데이트
                    return false
                } else {
                    guard let object = petKeywordData.toCoreData(context: context) else { return false }
                    afterOperation(context: context)
                    return true
                }
            } catch let error as NSError {
                print("")
            }
        default:
            break
        }
        return false
    }

    func fetchPetKeyword() -> [PetKeywordData]? {
        var petKeywordData = PetKeywordData()

        do {
            guard let objects = try fetchObjects(PetKeyword.self, sortBy: nil, predicate: nil) else {
            return nil
            }
            guard let object = objects.first else { return nil }
            guard let keywords = object.keywords as? [String] else { return nil }
            petKeywordData.keywords = keywords
            petKeywordData.pet = object.pet
            return [petKeywordData]
        } catch let error as NSError {
            print("")
            return nil
        }
        return nil
    }

    func updatePetKeyword(petKeyword: PetKeywordData) {
        guard let context = context else { return }
        guard let objectID = petKeyword.objectID else { return }
        guard let object = context.object(with: objectID) as? PetKeyword else {
            return
        }

        object.pet = petKeyword.pet
        object.keywords = petKeyword.keywords as NSObject
        afterOperation(context: context)
    }

    func delete(petKeywordData: PetKeywordData) {
        guard let objectID = petKeywordData.objectID else { return }
        let predicate = NSPredicate(format: "objectID = %@", objectID)
        do {
            let delete = try deleteObject(PetKeyword.self, predicate: predicate)
            if delete {
                print("Delete Success")
            } else {
                print("Delete Fail")
            }
            afterOperation(context: context)
        } catch let error as NSError {
            print("")
        }
    }
}

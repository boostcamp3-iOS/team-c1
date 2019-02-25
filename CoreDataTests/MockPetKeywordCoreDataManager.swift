//
//  MockPetKeywordCoreDataManager.swift
//  CoreDataTests
//
//  Created by 강준영 on 25/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
@testable import CoCo

class MockPetKeywordCoreDataManager: PetKeywordCoreDataManagerType {
    func fetchOnlyKeyword(pet: String) throws -> [String]? {
        return ["배변", "놀이", "뷰티", "스타일"]
    }

    func fetchOnlyPet() throws -> String? {
        return "고양이"
    }

    func deleteAllObjects(pet: String) throws -> Bool {
        if pet == "고양이" || pet == "강아지" {
            return true
        } else {
            return false
        }
    }

    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T)
        throws -> Bool {
        if coreDataStructType is PetKeywordData {
            if let petKeyword = coreDataStructType as? PetKeywordData {
                guard let keyword = petKeyword.keywords else {
                    return false
                }
                if keyword.count >= 2 {
                    return true
                }
            }
            return false
        } else {
            return false
        }
    }

    func fetchObjects(pet: String?) throws -> [CoreDataStructEntity]? {
        if let pet = pet {
            return [PetKeywordData(pet: pet, keywords: ["배변", "뷰티", "놀이"])]
        } else {
            return [PetKeywordData(pet: "강아지", keywords: ["배변", "뷰티", "놀이"]), PetKeywordData(pet: "고양이", keywords: ["배변", "뷰티", "놀이"])]
        }
    }

    func updateObject<T: CoreDataStructEntity>(_ coreDataStructType: T)
        throws -> Bool {
        if coreDataStructType is PetKeywordData {
            return true
        } else {
            return false
        }
    }

    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T)
        throws -> Bool {
        if coreDataStructType is PetKeywordData {
            return true
        } else {
            return false
        }
    }
}

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
    func fetchObjects(pet: String?, completion: @escaping ([CoreDataStructEntity]?, Error?) -> Void) {
        if let pet = pet {
            completion([PetKeywordData(pet: pet, keywords: ["배변", "뷰티", "놀이"])], nil)
        } else {
            completion([PetKeywordData(pet: "강아지", keywords: ["배변", "뷰티", "놀이"]), PetKeywordData(pet: "고양이", keywords: ["배변", "뷰티", "놀이"])], nil)
        }
    }

    func fetchOnlyKeyword(pet: String, completion: @escaping (([String]?, Error?) -> Void)) {
        completion(["배변", "놀이", "뷰티", "스타일"], nil)
    }

    func fetchOnlyPet(completion: @escaping (String?, Error?) -> Void) {
        completion("고양이", nil)
    }

    func deleteAllObjects(pet: String, completion: @escaping (Bool, Error?) -> Void) {
        if pet == "고양이" || pet == "강아지" {
            completion(true, nil)
        } else {
            completion(false, nil)
        }
    }

    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T, completion: @escaping (Bool, Error?) -> Void) {
        if let petKeyword = coreDataStructType as? PetKeywordData {
            guard let keyword = petKeyword.keywords else {
                return
            }
            if keyword.count >= 2 {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        } else {
            completion(false, nil)
        }
    }

    func updateObject<T>(_ coreDataStructType: T, completion:@escaping
        (Bool) -> Void) {
        if coreDataStructType is PetKeywordData {
           completion(true)
        } else {
            completion(false)
        }
    }

    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T, completion: @escaping (Bool) -> Void) {
        if coreDataStructType is PetKeywordData {
            completion(true)
        } else {
            completion(false)
        }
    }

}

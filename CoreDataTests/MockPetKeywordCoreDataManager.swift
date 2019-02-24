//
//  MockPetKeywordCoreDataManager.swift
//  CoreDataTests
//
//  Created by 강준영 on 24/02/2019.
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
    
    func fetchOnlyKeyword(pet: String, completion: @escaping ([String]?) -> Void) {
        completion(["배변", "놀이", "뷰티", "스타일"])
    }
    
    func fetchOnlyPet(completion: @escaping (String?, Error?) -> Void) {
        completion(PetDefault.shared.pet.rawValue, nil)
    }
    
    func deleteAllObjects(pet: String, completion: @escaping (Bool, Error?) -> Void) {
        
    }
}

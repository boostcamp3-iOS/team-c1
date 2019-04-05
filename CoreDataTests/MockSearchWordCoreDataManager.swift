//
//  MockSearchWordCoreDataManager.swift
//  CoreDataTests
//
//  Created by 강준영 on 25/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
@testable import CoCo

class MockSearchWordCoreDataManager: SearchWordCoreDataManagerType {
    func fetchObjects(pet: String?, completion: @escaping ([CoreDataStructEntity]?, Error?) -> Void) {
        if let pet = pet {
            completion([SearchWordData(pet: pet, searchWord: "배변용품")], nil)
        } else {
            completion([SearchWordData(pet: "고양이", searchWord: "배변용품"), SearchWordData(pet: "강아지", searchWord: "강아지간식")], nil)
        }
    }

    func fetchOnlySearchWord(pet: String, completion: @escaping (([String]?, Error?) -> Void)) {
        if pet == "고양이" || pet == "강아지" {
            completion(["쿠션", "신발", "옷"], nil)
        } else {
            completion(nil, nil)
        }
    }

    func fetchWord(_ searchWord: String, pet: String, completion: @escaping (SearchWordData?, Error?) -> Void) {
        let searchWordData = SearchWordData(pet: "고양이", searchWord: "고양이 옷")
        if (pet == searchWordData.pet) && (searchWord == searchWordData.searchWord) {
            completion(searchWordData, nil)
        } else {
            completion(nil, nil)
        }
    }

    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T, completion: @escaping (Bool, Error?) -> Void) {
        if coreDataStructType is SearchWordData {
            completion(true, nil)
        } else {
            completion(false, nil)
        }
    }

    func deleteAllObjects(pet: String, completion: @escaping (Bool, Error?) -> Void) {
        if pet == "고양이" || pet == "강아지" {
            completion(true, nil)
        } else {
            completion(false, nil)
        }
    }

    func updateObject<T>(_ coreDataStructType: T, completion:@escaping
        (Bool) -> Void) {
        if coreDataStructType is SearchWordData {
            completion(true)
        } else {
            completion(false)
        }
    }

    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T, completion: @escaping (Bool) -> Void) {
        if coreDataStructType is SearchWordData {
            completion(true)
        } else {
            completion(false)
        }
    }
}

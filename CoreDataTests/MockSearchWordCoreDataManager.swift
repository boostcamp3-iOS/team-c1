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

    @discardableResult func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is SearchWordData {
            return true
        } else {
            return false
        }
    }

    func fetchOnlySearchWord(pet: String) throws -> [String]? {
        if pet == "고양이" || pet == "강아지" {
            return ["쿠션", "신발", "옷"]
        } else {
            return nil
        }
    }

    func fetchObjects(pet: String? = nil) throws -> [CoreDataStructEntity]? {
        if let pet = pet {
            return [SearchWordData(pet: pet, searchWord: "배변용품")]
        } else {
            return [SearchWordData(pet: "고양이", searchWord: "배변용품"), SearchWordData(pet: "강아지", searchWord: "강아지간식")]
        }
    }

    func updateObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is SearchWordData {
            return true
        } else {
            return false
        }
    }

    @discardableResult func updateObject(searchWord: String, pet: String) throws -> Bool {
        if pet == "고양이" || pet == "강아지" {
            return true
        } else {
            return false
        }
    }

    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is SearchWordData {
            return true
        } else {
            return false
        }
    }

    @discardableResult func deleteAllObjects(pet: String) throws ->  Bool {
        if pet == "고양이" || pet == "강아지" {
            return true
        } else {
            return false
        }
    }
}

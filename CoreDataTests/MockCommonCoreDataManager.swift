//
//  MockCommonCoreDataManager.swift
//  CoreDataTests
//
//  Created by 강준영 on 24/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
@testable import CoCo

class MockCommonCoreDataManager: CommonCoreDataManagerType {
    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T, comepletion: @escaping (Bool, Error?) -> Void) {
        switch coreDataStructType {
        case is MyGoodsData:
            if coreDataStructType is MyGoodsData {
                comepletion(true, nil)
            } else {
                 comepletion(false, nil)
            }
        case is PetKeywordData:
            if coreDataStructType is PetKeywordData {
                 comepletion(true, nil)
            } else {
                comepletion(false, nil)
            }
        case is SearchWordData:
            if coreDataStructType is SearchWordData {
                comepletion(true, nil)
            } else {
                 comepletion(false, nil)
            }
        default:
            comepletion(false, nil)
        }
    }
    
    func updateObject<T>(_ coreDataStructType: T,
                         completion: @escaping (Bool) -> Void) {
        switch coreDataStructType {
        case is MyGoodsData:
            if coreDataStructType is MyGoodsData {
                completion(true)
            } else {
                completion(false)
            }
        case is PetKeywordData:
            if coreDataStructType is PetKeywordData {
                completion(true)
            } else {
                completion(false)
            }
        case is SearchWordData:
            if coreDataStructType is SearchWordData {
                completion(true)
            } else {
                completion(false)
            }
        default:
            completion(false)
        }
        
    }
    
    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T, completion: @escaping (Bool) -> Void) {
        switch coreDataStructType {
            case is MyGoodsData:
            if coreDataStructType is MyGoodsData {
                completion(true)
            } else {
                completion(false)
            }
            case is PetKeywordData:
            if coreDataStructType is PetKeywordData {
                completion(true)
            } else {
                completion(false)
            }
            case is SearchWordData:
            if coreDataStructType is SearchWordData {
                completion(true)
            } else {
                completion(false)
            }
            default:
            completion(false)
        }
        
    }
    
}

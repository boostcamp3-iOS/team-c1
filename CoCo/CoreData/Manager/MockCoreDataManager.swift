//
//  MockCoreDataManager.swift
//  CoCo
//
//  Created by 강준영 on 31/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

class MockCoreDataManager: CoreDataManagerProtocol {
    
    var mockCoreData: [CoreDataEntity]?
    var mockMyGoodsCoreData = [MyGoodsData]()
    var mockPetKeywordCoreData = [PetKeywordData]()
    var mockSearchKeywordCoreData = [SearchKeywordData]()
    
    func fetchObjects<T>(_ entityClass: T.Type, sortBy: [NSSortDescriptor]?, predicate: NSPredicate?) throws -> [T]? where T : NSManagedObject {
        return mockCoreData as? [T]
        
    }
    
    func insertCoreData<T>(_ coreDataType: T) throws -> Bool where T : CoreDataEntity {
        guard var mockCoreData = mockCoreData else { return false }
        let length = mockCoreData.count
        print(length)
        //mockCoreData.append(coreDataType)
        print(mockCoreData)
        let newLength = mockCoreData.count
        print(newLength)
        if newLength == length + 1 {
            return true
        } else {
            return false
        }
    }
    
    func updateObject<T>(_ coreDataType: T) throws -> Bool where T : CoreDataEntity {
        guard let objectID = coreDataType.objectID else {
            return false
        }
        // 데이터 struct종류에 따라 나눠야 하나?
        return false
        
    }
    
    
    func deleteObject<T>(_ entityClass: T.Type, predicate: NSPredicate?) throws -> Bool where T : NSManagedObject {
        return false
    }
    
}

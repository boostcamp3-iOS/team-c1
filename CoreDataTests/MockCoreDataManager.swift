////
////  MockCoreDataManager.swift
////  CoCo
////
////  Created by 강준영 on 31/01/2019.
////  Copyright © 2019 Team CoCo. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//class MockCoreDataManager: CoreDataManagerType {
//    func fetch<T>(_ coreDataType: T.Type, sortBy: [NSSortDescriptor]?, predicate: NSPredicate?) throws -> [T]? where T : CoreDataEntity {
//        return mockSearchKeywordCoreDataFir as? [T]
//    }
//    
//    
//    var mockCoreData: [CoreDataEntity]?
//    var mockMyGoodsCoreData = [MyGoodsData]()
//    var mockPetKeywordCoreDataFir: [PetKeywordData] = {
//       var petKeywords = PetKeywordData()
//        petKeywords.pet = "Cat"
//        petKeywords.keywords = ["놀이", "리빙", "푸드", "외출"]
//        return [petKeywords]
//    }()
//    var mockPetKeywordCoreDataSec: [PetKeywordData] = {
//        var petKeywords = PetKeywordData()
//        petKeywords.pet = "Dog"
//        petKeywords.keywords = ["뷰티", "헬스", "푸드", "외출", "스타일"]
//        return [petKeywords]
//    }()
//    var mockSearchKeywordCoreDataFir: [SearchKeywordData] = {
//        var searchKeywords = [SearchKeywordData]()
//        var searchKeyword1 = SearchKeywordData()
//        searchKeyword1.searchWord = "고양이 옷"
//        searchKeyword1.date = "2018-11-05 19:32:44"
//        var searchKeyword2 = SearchKeywordData()
//        searchKeyword2.searchWord = "고양이 사료"
//        searchKeyword2.date = "2019-01-05 11:32:44"
//        var searchKeyword3 = SearchKeywordData()
//        searchKeyword3.searchWord = "고양이 장난감"
//        searchKeyword3.date = "2019-01-06 10:32:44"
//        var searchKeyword4 = SearchKeywordData()
//        searchKeyword4.searchWord = "고양이 간식"
//        searchKeyword4.date = "2019-01-06 11:56:44"
//        searchKeywords.append(searchKeyword1)
//        searchKeywords.append(searchKeyword2)
//        searchKeywords.append(searchKeyword3)
//        searchKeywords.append(searchKeyword4)
//        return searchKeywords
//    }()
//    var mockSearchKeywordCoreDataSec: [SearchKeywordData] = {
//        var searchKeywords = [SearchKeywordData]()
//        var searchKeyword1 = SearchKeywordData()
//        searchKeyword1.searchWord = "강아지 신발"
//        searchKeyword1.date = "2019-01-06 11:55:44"
//        var searchKeyword2 = SearchKeywordData()
//        searchKeyword2.searchWord = "강아지 한복"
//        searchKeyword2.date = "2019-01-07 19:56:44"
//        var searchKeyword3 = SearchKeywordData()
//        searchKeyword3.searchWord = "강아지 샴푸"
//        searchKeyword3.date = "2019-01-12 15:32:44"
//        var searchKeyword4 = SearchKeywordData()
//        searchKeyword4.searchWord = "강아지 유산균"
//        searchKeyword4.date = "2019-01-20 14:51:44"
//        searchKeywords.append(searchKeyword1)
//        searchKeywords.append(searchKeyword2)
//        searchKeywords.append(searchKeyword3)
//        searchKeywords.append(searchKeyword4)
//        return searchKeywords
//    }()
//    var strSearch: [String] = ["강아지 옷", "강아지 간식", "강아지 사료"]
//    
//    func fetchObjects<T>(_ entityClass: T.Type, sortBy: [NSSortDescriptor]?, predicate: NSPredicate?) throws -> [T]? where T : CoreDataEntity {
//        return strSearch as? [T]
//        
//    }
//    
//    func insertCoreData<T>(_ coreDataType: T) throws -> Bool where T : CoreDataEntity {
//        guard let mockCoreData = mockCoreData else { return false }
//        let length = mockCoreData.count
//        print(length)
//        //mockCoreData.append(coreDataType)
//        print(mockCoreData)
//        let newLength = mockCoreData.count
//        print(newLength)
//        if newLength == length + 1 {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    func updateObject<T>(_ coreDataType: T) throws -> Bool where T : CoreDataEntity {
//        guard let objectID = coreDataType.objectID else {
//            return false
//        }
//        // 데이터 struct종류에 따라 나눠야 하나?
//        return false
//        
//    }
//    
//    
//    func deleteObject<T>(_ entityClass: T.Type, predicate: NSPredicate?) throws -> Bool where T : NSManagedObject {
//        return false
//    }
//    
//}

//
//  SearchKeywordDAO.swift
//  CoCo
//
//  Created by 강준영 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

class SearchKeywordCoreDataManager: SearchWordCoreDataManagerType,  CoreDataManagerFunctionImplementType {
    // MARK: - Methodes
    // Insert Method
    @discardableResult func insert<T>(_ coreDataType: T) throws -> Bool where T: CoreDataStructEntity {
        switch coreDataType {
        case is SearchWordData:
            guard let context = context else { return false }
            guard let searchKeywordData = coreDataType as? SearchWordData else {
                return false
            }

            do {
                // SearchKeyword Entity에 검색에가 존재하는 지 확인
                let object = fetchWord(searchKeywordData.searchWord, pet: searchKeywordData.pet)
                // 검색어가 존재하면 업데이트
                if object != nil {
                    print("Alreay stored, So Update")
                    try updateObject(searchKeywordData)
                    // 존재하지 않으면 검색어 데이터 추가
                } else {
                    let searchKeyword = SearchWord(context: context)
                    searchKeyword.date = searchKeywordData.date
                    searchKeyword.searchWord = searchKeywordData.searchWord
                    searchKeyword.pet = searchKeywordData.pet
                    afterOperation(context: context)
                    print("Insert Successive, word: \(searchKeyword.searchWord)")
                }
                return true
            } catch let error as NSError {
                print("insert error \(error)")
            }
        default:
            break
        }
        return false
    }

    // MARK: - Fetch Method
    // Fetch All of SearchKeyWordData
    func fetchObjects(pet: String) throws -> [CoreDataStructEntity]? {
        guard let context = context else { return nil }
        var searchWordDatas = [SearchWordData]()
        // 검색날짜별로 오름차순
        let sort = NSSortDescriptor(key: #keyPath(SearchWord.date), ascending: true)
        let predicate = NSPredicate(format: "pet = %@", pet)
        let request: NSFetchRequest<SearchWord>
        
        if #available(iOS 10.0, *) {
            let tmpRequest: NSFetchRequest<SearchWord> = SearchWord.fetchRequest()
            request = tmpRequest
        } else {
            let entityName = String(describing: SearchWord.self)
            request = NSFetchRequest(entityName: entityName)
        }
        
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        request.sortDescriptors = [sort]
        
        let objects = try context.fetch(request)
        
        if objects.count > 0 {
            for object in objects {
                var searchWordData = SearchWordData()
                searchWordData.objectID = object.objectID
                searchWordData.date = object.date
                searchWordData.searchWord = object.searchWord
                searchWordData.pet = object.pet
                searchWordDatas.append(searchWordData)
            }
            return searchWordDatas
        } else {
            throw CoreDataError.fetch(message: "PetKeyword Entity has not data, So can not fetch data")
        }
    }
    
    // Fetch Only SearchWords
    func fetchOnlySearchWord(pet: String) throws -> [String]? {
        var searchArrays = [String]()
        do {
            guard let objects = try fetchObjects(pet: pet) else {
                throw CoreDataError.fetch(message: "SearchKeyword Entity has not search data, So can not fetch data")
            }
            guard  let searchKeywords = objects as? [SearchWordData] else {
                return nil
            }
            for searchKeyword in searchKeywords {
                searchArrays.append(searchKeyword.searchWord)
            }
            return searchArrays
        } catch let error as NSError {
            print("fetch error \(error)")
        }
        return nil
    }

    // Fetch SearchKeyWordData's SearchWord - 검색 데이터를 추가하기전에, 기존에 동일한 검색어가 존재하는 지 확인하기 위해 구현
    private func fetchWord(_ searchKeyword: String, pet: String) -> SearchWordData? {
        var searchWordData: SearchWordData?
        do {
            guard let objects = try fetchObjects(pet: pet) else {
                // 기존에 동일한 검색 데이터가 있는 지, 없는 지  확인해야 하기 때문에 오류를 던지지 않음
                return nil
            }
            guard let searchWordDatas = objects as? [SearchWordData] else {
                return nil
            }
            searchWordDatas.forEach { (data) in
                if data.searchWord == searchKeyword {
                   searchWordData = data
                }
            }
        } catch let error as NSError {
            print("\(error)")
        }
        return searchWordData
    }

    // MARK: - Update Method
    // Update SearchKeyword Data
    
    @discardableResult func updateObject<T>(_ coreDataStructType: T) throws -> Bool {
        switch coreDataStructType {
        case is SearchWordData:
            guard let context = context else { return false }
            guard let searchWordData = coreDataStructType as? SearchWordData else {
                return false
            }
            guard let objectID = searchWordData.objectID else { throw CoreDataError.update(message: "Can not find this data(\(searchWordData)), So can not update")}
            guard let object = context.object(with: objectID) as? SearchWord else {
                return false
            }
            object.date = searchWordData.date
            object.searchWord = searchWordData.searchWord
            afterOperation(context: context)
            print("Update Successive => \(object)")
        default:
            return false
        }
        return false
    }
    
    @discardableResult func updateObject(with searchWord: String, pet: String) throws -> Bool {
        let object = fetchWord(searchWord, pet: pet)
        if var searchWordObject = object {
            searchWordObject.date = searchWordObject.createDate()
            return true
        } else {
            return false
        }
    }
  
    // MARK: - Delete Method
    // Delete SearchKeyword Data
    @discardableResult func deleteObject<T>(_ coreDataStructType: T) throws -> Bool where T : CoreDataStructEntity {
        switch coreDataStructType {
        case is SearchWordData:
            guard let context = context else { return false }
            guard let searchKeywordData = coreDataStructType as? SearchWordData else {
                return false
            }
            if let objectID = searchKeywordData.objectID {
                let object = context.object(with: objectID)
                context.delete(object)
                afterOperation(context: context)
                print("Delete Successive")
                return true
            } else {
                throw CoreDataError.delete(message: "Can not find this data(\(searchKeywordData)), So can not delete")
            }
        default:
            return false
        }
    }
    
    @discardableResult func deleteAllObjects(pet: String) throws -> Bool {
        guard let context = context else { return false }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchWord")
        let predicate = NSPredicate(format: "pet = %@", pet)
        
        fetchRequest.predicate = predicate
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            return true
            
        } catch {
            throw CoreDataError.delete(message: "Can't delete data")
        }
        return false
    }
}


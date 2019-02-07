//
//  SearchKeywordDAO.swift
//  CoCo
//
//  Created by 강준영 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

class SearchWordCoreDataManager: SearchWordCoreDataManagerType, CoreDataManagerFunctionImplementType {
    // Insert Method
    /**
     SearchWord Entity에 데이터 삽입.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - coreDataStructType: coreDataStructType 프로토콜을 채택하는 CoreData Struct.
     */
    @discardableResult func insert<T>(_ coreDataStructType: T) throws -> Bool {
        switch coreDataStructType {
        case is SearchWordData:
            guard let context = context else {
                return false
            }
            guard let searchKeywordData = coreDataStructType as? SearchWordData else {
                return false
            }
            do {
                // SearchKeyword Entity에 검색에가 존재하는 지 확인
                // 검색어가 존재하면 업데이트
                if try fetchWord(searchKeywordData.searchWord, pet: searchKeywordData.pet) != nil {
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
                throw CoreDataError.update(message: "Can't not update \(error)")
            }
        default:
            return false
        }
    }

    // MARK: - Fetch Method
    /**
     SearchWord의 모든 데이터를 오름차순으로 가져옴
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 데이터를 가져오기 위한 파마리터.
     기본값은 nil로, 값을 넣어주지 않으면 고양이와 강아지의 모든 데이터를 가져온다.
     */
    // Fetch All of SearchKeyWordData
    func fetchObjects(pet: String? = nil) throws -> [CoreDataStructEntity]? {
        guard let context = context else {
            return nil
        }
        var searchWordDatas = [SearchWordData]()
        let sort = NSSortDescriptor(key: #keyPath(SearchWord.date), ascending: true)
        let request: NSFetchRequest<SearchWord>
        
        if #available(iOS 10.0, *) {
            let tmpRequest: NSFetchRequest<SearchWord> = SearchWord.fetchRequest()
            request = tmpRequest
        } else {
            let entityName = String(describing: SearchWord.self)
            request = NSFetchRequest(entityName: entityName)
        }
        
        if let pet = pet {
            let predicate = NSPredicate(format: "pet = %@", pet)
            request.predicate = predicate
        }
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [sort]
        
        let objects = try context.fetch(request)
        
        if !objects.isEmpty {
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
    
    /**
     SearchWord의 모든 검색어를 가져옴
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 데이터를 가져오기 위한 파마리터.
     */
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
            throw CoreDataError.fetch(message: "Can't fetch data \(error)")
        }
    }

    /**
     SearchWord에 특정 갬색어가 있는 지 확인.
     검색 데이터를 추가하기전에, 기존에 동일한 검색어가 존재하는 지 확인하기 위해 구현
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 데이터를 가져오기 위한 파마리터.
     - searchWord: 확인하려는 검색어
     */
    func fetchWord(_ searchWord: String, pet: String) throws -> SearchWordData? {
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
                if data.searchWord == searchWord {
                   searchWordData = data
                }
            }
        } catch let error as NSError {
            throw CoreDataError.fetch(message: "Can't fetch data \(error)")
        }
        return searchWordData
    }

    // MARK: - Update Method
    /**
     파라미터로 넣은 구조체와 동일한 데이터 모든 내용을 업데이트한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - coreDataStructType: coreDataStructType 프로토콜을 채택하는 CoreData Struct
     */
    @discardableResult func updateObject<T>(_ coreDataStructType: T) throws -> Bool {
        switch coreDataStructType {
        case is SearchWordData:
            guard let context = context else {
                return false
            }
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
            return true       
            print("Update Successive => \(object)")
        default:
            return false
        }
    }
    
    /**
     코어데이타에 저장된 특정 검색어의 날짜만 업데이트 한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - searchWord : 날짜를 업데이트 할 특정 검색어
     - pet : 특정 펫의 데이터를 가져오기 위한 파라미터
     */
    @discardableResult func updateObject(with searchWord: String, pet: String) throws -> Bool {
        do {
            let object = try fetchWord(searchWord, pet: pet)
            if var searchWordObject = object {
                searchWordObject.date = searchWordObject.createDate()
                return true
            }
        } catch let error as NSError {
            throw CoreDataError.fetch(message: "Can't fetch data \(error)")
        }
        return false
    }
  
    // MARK: - Delete Method
    /**
     코어데이타에 저장된 SearchWord 데이터를 삭제한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - coreDataStructType: coreDataStructType 프로토콜을 채택하는 CoreData Struct.
     */
    @discardableResult func deleteObject<T>(_ coreDataStructType: T) throws -> Bool {
        switch coreDataStructType {
        case is SearchWordData:
            guard let context = context else {
                return false
            }
            guard let searchKeywordData = coreDataStructType as? SearchWordData else {
                return false
            }
            if let objectID = searchKeywordData.objectID {
                let object = context.object(with: objectID)
                context.delete(object)
                afterOperation(context: context)
                print("Delete Successive")
                return true
            }
        default:
            return false
        }
        return false
    }
    
    /**
     코어데이타에 저장된 SearchWord의 모든 데이터를 삭제한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - pet : 특정 펫에 대한 데이터만을 지우기 위한 파라미터.
     */
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
    }
}


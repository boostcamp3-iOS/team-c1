//
//  SearchKeywordDAO.swift
//  CoCo
//
//  Created by 강준영 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

class SearchKeywordCoreDataManager: CoreDataManager {
    // MARK: - Properties
    let appDelegate: AppDelegate?
    let context: NSManagedObjectContext?
    
    init(appDelegate: AppDelegate, context: NSManagedObjectContext) {
        self.appDelegate = appDelegate
        self.context = context
    }

    // MARK: - Methodes
    // Insert Method
    @discardableResult func insertCoreData<T>(_ coreDataType: T) throws -> Bool where T: CoreDataEntity {
        guard let context = context else {
            return false
        }
        switch coreDataType {
        case is SearchKeywordData:
            guard let searchKeywordData = coreDataType as? SearchKeywordData
                else {
                    return false
            }

            do {
                // SearchKeyword Entity에 검색에가 존재하는 지 확인
                let object = fetchWord(searchKeywordData)
                // 검색어가 존재하면 업데이트
                if object != nil {
                    print("Alreay stored, So Update")
                    try updateSearchKeyword(searchKeyword: searchKeywordData)
                    // 존재하지 않으면 검색어 데이터 추가
                } else {
                    let searchKeyword = SearchKeyword(context: context)
                    searchKeyword.date = searchKeywordData.date as NSDate
                    searchKeyword.searchWord = searchKeywordData.searchWord
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
    func fetchSearchKeyword() throws -> [SearchKeywordData]? {
        // 검색 날짜별로 오름차순 정렬
        let sort = NSSortDescriptor(key: #keyPath(SearchKeyword.date), ascending: true)
        var searchKeywordResults = [SearchKeywordData]()

        do {
            guard let objects = try fetchObjects(SearchKeyword.self, sortBy: [sort], predicate: nil) else {
                throw CoreDataError.fetch(message: "SearchKeyword Entity has not data, So can not fetch data")
            }
            for object in objects {
                var search = SearchKeywordData()
                search.date = object.date as Date
                search.searchWord = object.searchWord
                search.objectID = object.objectID
                searchKeywordResults.append(search)
            }
            return searchKeywordResults
        } catch let error as NSError {
            print("fetch error \(error)")
            return nil
        }
    }

    // Fetch Only SearchWords
    func fetchOnlySearchWord() -> [String]? {
        let sort = NSSortDescriptor(key: #keyPath(SearchKeyword.date), ascending: true)
        var searchArrays = [String]()

        do {
            guard let objects = try fetchObjects(SearchKeyword.self, sortBy: [sort], predicate: nil) else {
                throw CoreDataError.fetch(message: "SearchKeyword Entity has not search data, So can not fetch data")
            }
            for object in objects {
                searchArrays.append(object.searchWord)
            }
            return searchArrays
        } catch let error as NSError {
            print("fetch error \(error)")
        }
        return nil
    }

    // Fetch SearchKeyWordData's SearchWord - 검색 데이터를 추가하기전에, 기존에 동일한 검색어가 존재하는 지 확인하기 위해 구현
    private func fetchWord(_ searchKeywrodData: SearchKeywordData) -> SearchKeyword? {
        let searchWord = searchKeywrodData.searchWord
        let predicate = NSPredicate(format: "searchWord = %@", searchWord)
        do {
            guard let objects = try fetchObjects(SearchKeyword.self, sortBy: nil, predicate: predicate) else {
                // 기존에 동일한 검색 데이터가 있는 지, 없는 지  확인해야 하기 때문에 오류를 던지지 않음
                return nil
            }
            guard let object = objects.first else { return nil }
            return object
        } catch let error as NSError {
            print("\(error)")
        }
        return nil
    }

    // MARK: - Update Method
    // Update SearchKeyword Data
    @discardableResult func updateSearchKeyword(searchKeyword: SearchKeywordData) throws -> Bool {
        guard let context = context else { return false }
        guard let objectID = searchKeyword.objectID else { throw CoreDataError.update(message: "Can not find this data(\(searchKeyword)), So can not update")}
        guard let object = context.object(with: objectID) as? SearchKeyword else {
            return false
        }
        object.date = searchKeyword.date as NSDate
        object.searchWord = searchKeyword.searchWord
        afterOperation(context: context)
        print("Update Successive => \(object)")
        return true
    }
    
    func updateObject<T>(_ coreDataType: T) throws -> Bool where T : CoreDataEntity {
        return false
    }

    // MARK: - Delete Method
    // Delete SearchKeyword Data
    @discardableResult func deleteSearchKeyword(searchKeyword: SearchKeywordData) throws -> Bool {
        guard let context = context else {
            return false
        }
        if let objectID = searchKeyword.objectID {
            let object = context.object(with: objectID)
            context.delete(object)
            afterOperation(context: context)
            print("Delete Successive")
            return true
        } else {
            throw CoreDataError.delete(message: "Can not find this data(\(searchKeyword)), So can not delete")
        }
    }

    // Delete using SearchWord - 검색단어로 데이터 지움
    @discardableResult func deleteUsingKeyword(keyword: String) throws -> Bool {
        guard let context = context else { return false }
        let predicate = NSPredicate(format: "searchWord = %@", keyword)
        do {
            guard let objects = try fetchObjects(SearchKeyword.self, sortBy: nil, predicate: predicate) else {
            throw CoreDataError.delete(message: "Can not find this keyword(\(keyword)), So can not delete")
            }
            guard let object = objects.first else { return false }
            context.delete(object)
            return true
        } catch let error as NSError {
            print("\(error)")
        }
        return false
    }
}

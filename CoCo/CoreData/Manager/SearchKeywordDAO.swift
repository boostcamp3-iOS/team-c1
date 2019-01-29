//
//  SearchKeywordDAO.swift
//  CoCo
//
//  Created by 강준영 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

class SearchKeywordDAO: CoreDataManager {
    static let shared = SearchKeywordData()

    func insertCoreData<T>(coreDataType: T) throws -> Bool where T: CoreDataEntity {
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
                //TODO: 검색에 존재하면 업데이트

                // 코어데이터에 삽입
                guard let object = searchKeywordData.toCoreData(context: context) else { return false }
                    afterOperation(context: context)
                    return true

            } catch let error as NSError {
                print("")
            }
        default:
            break
        }
        return false
    }

    // fetch
    func fetchSearchKeyword() -> [SearchKeywordData]? {
        var searchKeywordResults = [SearchKeywordData]()
        let sort = NSSortDescriptor(key: #keyPath(SearchKeyword.date), ascending: true)
        do {
            guard let objects = try fetchObjects(SearchKeyword.self, sortBy: [sort], predicate: nil) else {
                return nil
            }
            for object in objects {
                var search = SearchKeywordData()
                search.date = object.date as Date
                search.searchWord = object.searchWord
                searchKeywordResults.append(search)
            }
            return searchKeywordResults
        } catch let error as NSError {
            return nil
        }
    }

    // update
    func updateSearchKeyword(searchKeyword: SearchKeywordData) throws-> Bool {
        guard let context = context else { return false }
        guard let objectID = searchKeyword.objectID else { return false }
        guard let object = context.object(with: objectID) as? SearchKeyword else {
            return false
        }
        object.date = searchKeyword.date as NSDate
        object.searchWord = searchKeyword.searchWord
        afterOperation(context: context)
        return true
    }

    // delete
    func deleteSearchKeyword(searchKeyword: SearchKeywordData) throws -> Bool {
        guard let context = context else { return false }
        guard let objectID = searchKeyword.objectID else { return false }
        guard let object = context.object(with: objectID) as? SearchKeyword else {
            return false
        }
        context.delete(object)
        afterOperation(context: context)
        return true
    }
}

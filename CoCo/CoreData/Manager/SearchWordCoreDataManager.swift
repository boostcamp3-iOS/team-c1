//
//  SearchKeywordDAO.swift
//  CoCo
//
//  Created by 강준영 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
import CoreData

class SearchWordCoreDataManager: SearchWordCoreDataManagerType {
    // MARK: - Fetch Method
    /**
     SearchWord의 모든 데이터를 오름차순으로 가져옴
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 데이터를 가져오기 위한 파마리터.
     기본값은 nil로, 값을 넣어주지 않으면 고양이와 강아지의 모든 데이터를 가져온다.
     */
    // Fetch All of SearchKeyWordData
    func fetchObjects(pet: String? = nil, completion:@escaping ([CoreDataStructEntity]?, Error?) -> Void) {
        let sort = NSSortDescriptor(key: #keyPath(SearchWord.date), ascending: true)
        var searchWordDatas = [SearchWordData]()
        var predicate: NSPredicate?

        if let pet = pet {
            predicate = NSPredicate(format: "pet = %@", pet)

        }

        fetchObjects(SearchWord.self, sortBy: [sort], predicate: predicate) { (fetchResult, error) in
            if let error = error {
                completion(nil, error)
            }
            guard let objects = fetchResult else {
                return
            }
            if !objects.isEmpty {
                for object in objects {
                    var searchWordData = SearchWordData()
                    searchWordData.mappinng(from: object)
                    searchWordDatas.append(searchWordData)
                }
                completion(searchWordDatas, nil)
            } else {
                completion(nil, nil)
            }
        }
    }

    /**
     SearchWord의 모든 검색어를 가져옴
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 데이터를 가져오기 위한 파마리터.
     */
    func fetchOnlySearchWord(pet: String, completion: @escaping (([String]?, Error?) -> Void)) {
        var searchArrays = [String]()
        fetchObjects(pet: pet) { (fetchResult, error) in
            if let error = error {
                completion(nil, error)
            }
            guard  let searchKeywords = fetchResult as? [SearchWordData] else {
                return
            }
            for searchKeyword in searchKeywords {
                searchArrays.append(searchKeyword.searchWord)
            }
            completion(searchArrays, nil)
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
    func fetchWord(_ searchWord: String, pet: String, completion: @escaping (SearchWordData?, Error?) -> Void) {
        var searchWordData: SearchWordData?

            fetchObjects(pet: pet) { (fetchResult, error) in
                if let error = error {
                    completion(nil, error)
                }
                guard let searchWordDatas = fetchResult as? [SearchWordData] else {
                    return
                }
                searchWordDatas.forEach { (data) in
                    if data.searchWord == searchWord {
                        searchWordData = data
                    }
                }
                completion(searchWordData, nil)
            }
    }

    /**
     코어데이타에 저장된 특정 검색어의 날짜만 업데이트 한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - searchWord : 날짜를 업데이트 할 특정 검색어
     - pet : 특정 펫의 데이터를 가져오기 위한 파라미터
     */
    func updateObject(searchWord: String, pet: String, completion:@escaping (Bool, Error?) -> Void) {
        guard let context = context else {
            return
        }
        fetchWord(searchWord, pet: pet) { [weak self] (fetchResult, error) in
            if let error = error {
                completion(false, error)
            }
            if var searchWordObject = fetchResult, let objectID = searchWordObject.objectID {
                let object = context.object(with: objectID)
                searchWordObject.date = searchWordObject.createDate()
                searchWordObject.mappinng(to: object)
                self?.afterOperation(context: context)
            }
            completion(true, nil)
        }
    }

    // MARK: - Delete Method
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

//
//  PetKeywordDAO.swift
//  CoCo
//
//  Created by 강준영 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
import CoreData

class PetKeywordCoreDataManager: PetKeywordCoreDataManagerType {
    // MARK: - Fetch Methodes
    /**
     PetKeyword의 모든 데이터를 오름차순으로 가져옴
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
        - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 데이터를 가져오기 위한 파마리터.
        기본값은 nil로, 값을 넣어주지 않으면 고양이와 강아지의 모든 데이터를 가져온다.
     */
    // 데이터 타입(Keyword, Pet)변경해서 리턴
    func fetchObjects(pet: String? = nil, completion: @escaping ([CoreDataStructEntity]?, Error?) -> Void) {
        var petKeywordDatas = [PetKeywordData]()
        var predicate: NSPredicate?
        let sort = NSSortDescriptor(key: #keyPath(PetKeyword.date), ascending: false)

        if let pet = pet {
            predicate = NSPredicate(format: "pet = %@", pet)
        }

        fetchObjects(PetKeyword.self, sortBy: [sort], predicate: predicate) { (fetchResult, error) in
            if let error = error {
                completion(nil, error)
            }
            guard let objects = fetchResult else {
                return
            }
            if !objects.isEmpty {
                for object in objects {
                    var petKeyword = PetKeywordData()
                    petKeyword.mappinng(from: object)
                    petKeywordDatas.append(petKeyword)
                }
                completion(petKeywordDatas, nil)
            } else {
                completion(nil, nil)
            }
        }
    }

    // Fetch Only Keyword Data
    /**
     특정펫의 키워드를 모두 가져온다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 키워드를 가져오기 위한 파마리터.
     */
    func fetchOnlyKeyword(pet: String, completion: @escaping (([String]?, Error?) -> Void)) {
        fetchObjects(pet: pet) { (fetchResult, error) in
            if let error = error {
                completion(nil, error)
            }
            guard let petKeywordDatas = fetchResult as? [PetKeywordData] else {
                return
            }
            guard let petKeywordData = petKeywordDatas.first else {
                return
            }
            completion(petKeywordData.keywords, nil)
        }
    }

    // Fetch Only Pet
    /**
     특정펫의 펫정보만을 가져온다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
        - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 펫정보를 가져오기 위한 파마리터.
     */
    func fetchOnlyPet(completion: @escaping (String?, Error?) -> Void) {
        var petKeywordData = PetKeywordData()
        let sort = NSSortDescriptor(key: #keyPath(PetKeyword.date), ascending: false)
        fetchObjects(PetKeyword.self, sortBy: [sort], predicate: nil) {
            (fetchResult, error) in
            if let error = error {
                completion(nil, error)
            }
            guard let objects = fetchResult else {
                return
            }
            if !objects.isEmpty {
                guard let firstObject = objects.first else {
                    return
                }
                petKeywordData.mappinng(from: firstObject)
                completion(petKeywordData.pet, nil)
            }
        }
    }

    // MARK: - Delete Method
    /**
     특정펫의 데이터를 삭제한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameters:
        - pet: 특정 펫의 데이터를 지우기위한 파라미터.
     */
    func deleteAllObjects(pet: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let container = container else {
            return
        }
        container.performBackgroundTask { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PetKeyword")
            let predicate = NSPredicate(format: "pet = %@", pet)

            fetchRequest.predicate = predicate
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(batchDeleteRequest)
                completion(true, nil)

            } catch {
                completion(false, error)
            }
        }

    }
}

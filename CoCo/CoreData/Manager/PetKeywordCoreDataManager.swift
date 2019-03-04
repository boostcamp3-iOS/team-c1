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
    func fetchObjects(pet: String? = nil) throws -> [CoreDataStructEntity]? {
        guard let context = context else { return nil }
        var petKeywordDatas = [PetKeywordData]()
        let request: NSFetchRequest<PetKeyword>
        let sort = NSSortDescriptor(key: #keyPath(PetKeyword.date), ascending: false)

        if #available(iOS 10.0, *) {
            let tmpRequest: NSFetchRequest<PetKeyword> = PetKeyword.fetchRequest()
            request = tmpRequest
        } else {
            let entityName = String(describing: PetKeyword.self)
            request = NSFetchRequest(entityName: entityName)
        }
        request.sortDescriptors = [sort]
        if let pet = pet {
            let predicate = NSPredicate(format: "pet = %@", pet)
            request.predicate = predicate
        }
        let objects = try context.fetch(request)

        if !objects.isEmpty {
            for object in objects {
                var petKeyword = PetKeywordData()
                petKeyword.mappinng(from: object)
                petKeywordDatas.append(petKeyword)
            }
            return petKeywordDatas
        } else {
            return nil
        }
    }

    // Fetch Only Keyword Data
    /**
     특정펫의 키워드를 모두 가져온다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 키워드를 가져오기 위한 파마리터.
     */
    func fetchOnlyKeyword(pet: String) throws -> [String]? {
        var keywords: [String]?
        do {
            guard let objects = try fetchObjects(pet: pet) else {
                throw CoreDataError.fetch(message: "PetKeyword Entity has not  data, So can not fetch data")
            }
            guard let petKeywordDatas = objects as? [PetKeywordData] else { return nil }
            guard let petKeywordData = petKeywordDatas.first else { return nil }
            keywords = petKeywordData.keywords
            return keywords
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }

    // Fetch Only Pet
    /**
     특정펫의 펫정보만을 가져온다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
        - pet: 해당하는 펫(고양이 또는 강아지)과 관련된 펫정보를 가져오기 위한 파마리터.
     */
    func fetchOnlyPet() throws -> String? {
        guard let context = context else { return nil }
        var petKeywordData = PetKeywordData()
        let sort = NSSortDescriptor(key: #keyPath(PetKeyword.date), ascending: false)
        let request: NSFetchRequest<PetKeyword>

        if #available(iOS 10.0, *) {
            let tmpRequest: NSFetchRequest<PetKeyword> = PetKeyword.fetchRequest()
            request = tmpRequest
        } else {
            let entityName = String(describing: PetKeyword.self)
            request = NSFetchRequest(entityName: entityName)
        }
        request.sortDescriptors = [sort]
        let objects = try context.fetch(request)

        if !objects.isEmpty {
            guard let firstObject = objects.first else {
                return nil
            }
            petKeywordData.mappinng(from: firstObject)
            return petKeywordData.pet
        } else {
            return nil
        }

    }

    // MARK: - Delete Method
    /**
     특정펫의 데이터를 삭제한다.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameters:
        - pet: 특정 펫의 데이터를 지우기위한 파라미터.
     */
    @discardableResult func deleteAllObjects(pet: String) throws -> Bool {
        guard let context = context else {
            return false
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PetKeyword")
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

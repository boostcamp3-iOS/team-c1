//
//  PetKeywordDummy.swift
//  CoCo
//
//  Created by 강준영 on 15/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

func petkeyWordCoreDataPrint() {
    let petKeywordDataManager = PetKeywordCoreDataManager()
    let dummy = PetKeywordDummy().petkeys

    do {
        for data in dummy {
            let insert = try petKeywordDataManager.insert(data)
        }
        let fetch = try petKeywordDataManager.fetchObjects()
    } catch let error {
        print(error)
    }
}

struct PetKeywordDummy {
    let cat = "고양이"
    let dog = "강아지"
    var petkeys = [PetKeywordData]()

    init() {
        var catKeyword = PetKeywordData(pet: self.cat, keywords: ["놀이", "배변", "스타일", "리빙"])
    //    catKeyword.objectID = NSManagedObjectID()
        var dogKeyword = PetKeywordData(pet: self.dog, keywords: ["헬스", "외출", "배변", "리빙"])
    //    dogKeyword.objectID = NSManagedObjectID()
        petkeys.append(catKeyword)
        petkeys.append(dogKeyword)
    }
}

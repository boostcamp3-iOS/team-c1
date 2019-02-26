//
//  SettingMyPetService.swift
//  CoCo
//
//  Created by 이호찬 on 18/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

class SettingPetAndKeywordService {

    private let petKeywordCoreDataManager: PetKeywordCoreDataManagerType

    let petDic = [0: "강아지", 1: "고양이"]
    let keywordDic = [0: "놀이", 1: "뷰티", 2: "헬스", 3: "푸드", 4: "스타일", 5: "리빙", 6: "외출", 7: "배변"]

    var petKeyword: PetKeywordData?

    init(petCoreData: PetKeywordCoreDataManagerType) {
        petKeywordCoreDataManager = petCoreData
    }

    func fetchPetKeywordData() {
        if let petKeyword = try? petKeywordCoreDataManager.fetchObjects(pet: nil)?.first {
            self.petKeyword = petKeyword as? PetKeywordData
        }
    }

    @discardableResult func insertPetKeywordData() -> Bool {
        guard let keyword = petKeyword?.keywords, let pet = petKeyword?.pet else {
            return false
        }
        let result = try? petKeywordCoreDataManager.insert(PetKeywordData(pet: pet, keywords: keyword))
        if let result = result {
            PetDefault.shared.pet = Pet(rawValue: pet) ?? .dog
            return result
        }
        return false
    }

}

//
//  Keyword.swift
//  CoCo
//
//  Created by 최영준 on 25/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

// MARK: - PetType
enum PetType: String {
    case dog = "강아지"
    case cat = "고양이"
}

// MAKR: - KeywordType & Keyword
enum KeywordType: String, CaseIterable {
    case play = "놀이"
    case beauty = "뷰티"
    case health = "헬스"
    case food = "푸드"
    case style = "스타일"
    case living = "리빙"
    case goingOut = "외출"
    case bowelMovement = "배변"
}

struct Keyword: Word {
    // MARK: - Properties
    let name: String
    let type: KeywordType

    // MARK: - Private properties
    private(set) var categories = [Category]()

    // MARK: - Initializer
    init(_ type: KeywordType, pet: PetType) {
        name = type.rawValue
        self.type = type
        categories = getCategories(type, pet: pet)
    }

    // MARK: - Get categories
    private func getCategories(_ type: KeywordType, pet: PetType) -> [Category] {
        switch type {
        case .play:
            return [Category(.toyTraining, pet: pet)]
        case .beauty:
            return [Category(.beautyBath, pet: pet)]
        case .health:
            return [Category(.healthCare, pet: pet)]
        case .food:
            return [Category(.feed, pet: pet),
                    Category(.snack, pet: pet)]
        case .style:
            return [Category(.fashionProducts, pet: pet)]
        case .living:
            return [Category(.cushionHouse, pet: pet),
                    Category(.tablewareWaterDispenser, pet: pet)]
        case .goingOut:
            return [Category(.outdoorProducts, pet: pet)]
        case .bowelMovement:
            return [Category(.bowelProducts, pet: pet)]
        }
    }
}

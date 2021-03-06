//
//  Keyword.swift
//  CoCo
//
//  Created by 최영준 on 25/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

enum Keyword: String, CaseIterable {
    case play = "놀이"
    case beauty = "뷰티"
    case health = "헬스"
    case food = "푸드"
    case style = "스타일"
    case living = "리빙"
    case goingOut = "외출"
    case bowelMovement = "배변"

    // MARK: - Methods
    /**
     해당 Keyword에 포함되는 Category 타입의 리스트를 반환한다.
     - Author: [최영준](https://github.com/0jun0815)
     */
    func getData() -> [Category] {
        switch self.rawValue {
        case "놀이" :
            return [.toyTraining]
        case "뷰티":
            return [.beautyBath]
        case "헬스":
            return [.healthCare]
        case "푸드":
            return [.feed, .snack]
        case "스타일":
            return [.fashionProducts]
        case "리빙":
            return [.cushionHouse, .tablewareWaterDispenser]
        case "외출":
            return [.outdoorProducts]
        case "배변":
            return [.bowelProducts]
        default:
            return [.toyTraining]
        }
    }
}

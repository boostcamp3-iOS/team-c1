//
//  Keyword.swift
//  CoCo
//
//  Created by 최영준 on 25/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

enum KeywordType: String, CaseIterable {
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
        switch self {
        case .play:
            return [.toyTraining]
        case .beauty:
            return [.beautyBath]
        case .health:
            return [.healthCare]
        case .food:
            return [.feed, .snack]
        case .style:
            return [.fashionProducts]
        case .living:
            return [.cushionHouse, .tablewareWaterDispenser]
        case .goingOut:
            return [.outdoorProducts]
        case .bowelMovement:
            return [.bowelProducts]
        }
    }
}

//
//  ErrorType.swift
//  CoCo
//
//  Created by 최영준 on 08/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

protocol ErrorType {
    var unknownError: String { get }
}

extension ErrorType {
    var unknownError: String { return  "알 수 없는 오류가 발생하였습니다." }
}

enum MyGoodsDataError: String, ErrorType {
    case invalidLink = "유효하지 않은 링크입니다."
    case lostData = "데이터가 유실되었습니다."
}

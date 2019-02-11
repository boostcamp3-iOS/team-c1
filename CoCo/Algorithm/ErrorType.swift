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

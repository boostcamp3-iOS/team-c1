//
//  Environment.swift
//  CoCo
//
//  Created by 이호찬 on 28/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

struct Environment {

    // MARK: - Properties
    // base URL
    var host: String
    var headerDic: [String: Any] = [:]

    // MARK: - Initializer
    init(host: String, headerDic: [String: Any]) {
        self.host = host
        self.headerDic = headerDic
    }
}

//
//  UserDefaults+FirstLaunch.swift
//  CoCo
//
//  Created by 최영준 on 19/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

extension UserDefaults {
    static let launchedBefore = "launchedBefore"
    static func isFirstLaunch() -> Bool {
        if UserDefaults.standard.bool(forKey: launchedBefore) {
            return false
        }
        return true
    }

}

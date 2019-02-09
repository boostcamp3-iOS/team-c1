//
//  NSManagedObject+.swift
//  CoCo
//
//  Created by 강준영 on 08/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    func value(forKeyPath keyPath: String) -> [String] {
        let value = super.value(forKeyPath: keyPath) as? [String]
        return value ?? []
    }
    func value(forKeyPath keyPath: String) -> String {
        let value = super.value(forKeyPath: keyPath) as? String
        return value ?? ""
    }
    
    func value(forKeyPath keyPath: String) -> Bool {
        guard let value = super.value(forKeyPath: keyPath) as? Bool else {
            return false
        }
        return value
    }
}

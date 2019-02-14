//
//  NSManagedObject+.swift
//  CoCo
//
//  Created by 강준영 on 08/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
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

    func value(forKeyPath keyPath: String) -> UIImage {
        guard let value = super.value(forKeyPath: keyPath) as? UIImage else {
            return UIImage()
        }
        return value
    }

    func petValue(forKeyPath keyPath: String) -> Pet? {
        guard let value = super.value(forKeyPath: keyPath) as? Pet else {
            return nil
        }
        return value
    }

    func keywordValue(forKeyPath keyPath: String) -> [Keyword]? {
        guard let value = super.value(forKeyPath: keyPath) as? [Keyword] else {
            return nil
        }
        return value
    }

}

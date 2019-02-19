//
//  MemoryStorage.swift
//  CoCo
//
//  Created by 이호찬 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

enum MemoryStorage {
    class MemoryCache: CacheStorage {

        let storage = NSCache<NSString, UIImage>()

        init() {
            storage.countLimit = 100
        }

        func store(value: UIImage, forKey key: String) {
            storage.setObject(value, forKey: key as NSString)
        }

        func remove(forKey key: String) {
            storage.removeObject(forKey: key as NSString)
        }

        func removeAll() {
            storage.removeAllObjects()
        }

        func retrieve(forKey key: String) -> UIImage? {
            return storage.object(forKey: key as NSString)
        }
    }
}

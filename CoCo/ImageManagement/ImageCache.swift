//
//  ImageCache.swift
//  CoCo
//
//  Created by 이호찬 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

protocol CacheStorage {
    func store(value: UIImage, forKey key: String)
    func remove(forKey key: String)
    func removeAll()
    func retrieve(forKey key: String) -> UIImage?
}

class ImageCache {

    let memoryStorage: MemoryStorage.MemoryCache

    init() {
        memoryStorage = MemoryStorage.MemoryCache()
    }

    func store(value: UIImage, forKey key: String) {
        memoryStorage.store(value: value, forKey: key)
    }

    func remove(forKey key: String) {
        memoryStorage.remove(forKey: key)
    }

    func removeAll() {
        memoryStorage.removeAll()
    }

    func retrieve(forKey Key: String) -> UIImage? {
        return memoryStorage.retrieve(forKey: Key)
    }
}

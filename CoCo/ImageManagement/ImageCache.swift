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
    let diskStorage: DiskStorage.DiskCache

    init() {
        memoryStorage = MemoryStorage.MemoryCache()
        diskStorage = DiskStorage.DiskCache(name: "coco")
    }

    func store(value: UIImage, forKey key: String, isDisk: Bool) {
        if isDisk {
            diskStorage.store(value: value, forKey: key)
        } else {
            memoryStorage.store(value: value, forKey: key)
        }
    }

    func remove(forKey key: String, isDisk: Bool) {
        if isDisk {
            diskStorage.remove(forKey: key)
        } else {
            memoryStorage.remove(forKey: key)
        }
    }

    func removeAll() {
        memoryStorage.removeAll()
        diskStorage.removeAll()
    }

    func retrieve(forKey key: String) -> UIImage? {
        if let image = diskStorage.retrieve(forKey: key) {
            return image
        }
        return memoryStorage.retrieve(forKey: key)
    }

    func getCacheSize() -> Int {
        return diskStorage.getCacheSize()
    }
}

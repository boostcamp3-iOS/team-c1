//
//  DiskStorage.swift
//  CoCo
//
//  Created by 이호찬 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

enum DiskStorage {
    class DiskCache: CacheStorage {

        let fileManager = FileManager()

        var directoryURL: URL?
        let diskCacheQueue: DispatchQueue

        init(name: String) {
            if let path = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
                directoryURL = path.appendingPathComponent(name)
            }
            diskCacheQueue = DispatchQueue(label: "coco.ImageCahce.diskCacheQueue.\(name)", qos: .background)
        }

        func store(value: UIImage, forKey key: String) {
            diskCacheQueue.async {
                guard let directoryURL = self.directoryURL else {
                    return
                }
                if !self.fileManager.fileExists(atPath: directoryURL.path) {
                    do {
                        try self.fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
                    } catch let error {
                        print(error)
                    }
                }
                let filePath = directoryURL.appendingPathComponent(key)
                self.fileManager.createFile(atPath: filePath.path, contents: value.pngData(), attributes: nil)
            }
        }

        func remove(forKey key: String) {
            diskCacheQueue.async {
                guard let directoryURL = self.directoryURL else {
                    return
                }
                let filePath = directoryURL.appendingPathComponent(key)
                do {
                    try self.fileManager.removeItem(atPath: filePath.path)
                } catch let err {
                    print(err)
                }
            }
        }

        func removeAll() {
            diskCacheQueue.async {
                guard let directoryURL = self.directoryURL else {
                    return
                }
                do {
                    try self.fileManager.removeItem(at: directoryURL)
                } catch let err {
                    print(err)
                }
            }
        }

        func retrieve(forKey key: String) -> UIImage? {
            guard let directoryURL = self.directoryURL else {
                return nil
            }
            let filePath = directoryURL.appendingPathComponent(key)
            if let image = UIImage(contentsOfFile: filePath.path) {
                return image
            }
            return nil
        }

    }
}

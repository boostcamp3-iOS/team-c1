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
        let diskCacheQueue: DispatchQueue

        var directoryURL: URL?

        init(name: String) {
            if let path = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
                directoryURL = path.appendingPathComponent(name)
            }
            diskCacheQueue = DispatchQueue(label: "coco.ImageCahce.diskCacheQueue.\(name)", qos: .background)
        }

        func store(value: UIImage, forKey key: String) {
//            var i = 0
            let newKey = createKey(key)
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
                let filePath = directoryURL.appendingPathComponent(newKey)
//                if let imageData = value.pngData() {
//                    let bytes = imageData.count
//                    i += bytes
//                }
                self.fileManager.createFile(atPath: filePath.path, contents: value.pngData(), attributes: nil)
            }
        }

        func remove(forKey key: String) {
            let newKey = createKey(key)
            diskCacheQueue.async {
                guard let directoryURL = self.directoryURL else {
                    return
                }
                let filePath = directoryURL.appendingPathComponent(newKey)
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
            let newKey = createKey(key)
            guard let directoryURL = self.directoryURL else {
                return nil
            }
            let filePath = directoryURL.appendingPathComponent(newKey)
            if let image = UIImage(contentsOfFile: filePath.path) {
                return image
            }
            return nil
        }

        func getCacheSize() -> Int {
            guard let directoryURL = self.directoryURL else {
                return 0
            }
            var fileSize = 0
            let path = directoryURL.path
            do {
                let attribute = try fileManager.attributesOfItem(atPath: path)
                fileSize = attribute[FileAttributeKey.size] as? Int ?? 0
            } catch let err {
                print(err)
            }
//            let bcf = ByteCountFormatter()
//            bcf.allowedUnits = [.useMB]
//            bcf.countStyle = .file
//            let string = bcf.string(fromByteCount: Int64(fileSize))
//            print("formatted result: \(string)")
            return fileSize
        }

        func createKey(_ key: String) -> String {
            return key.replacingOccurrences(of: "/", with: "")
        }
    }
}

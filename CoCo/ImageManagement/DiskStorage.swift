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
            diskCacheQueue.async { [weak self] in
                guard let self = self else {
                    return
                }
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
             
            }
        }
        
        func cacheFileURL(forKey key: String) -> URL {
            let fileName = cacheFileName(forKey: key)
            return directoryURL.appendingPathComponent(fileName)
        }
        
        func remove(forKey key: String) {
            <#code#>
        }
        
        func removeAll() {
            <#code#>
        }
        
        func retrieve(forKey key: String) -> UIImage? {
            <#code#>
        }
        
    }
}

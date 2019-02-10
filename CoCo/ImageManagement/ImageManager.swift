//
//  ImageManager.swift
//  CoCo
//
//  Created by 이호찬 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

extension UIImageView {

    static let imageCache = ImageCache()

    func setImage(url: String) {

        if let image = UIImageView.imageCache.retrieve(forKey: url) {
            DispatchQueue.main.async {
                self.image = image
            }
        }

        DispatchQueue.global().async {
            ShoppingNetworkManager.shared.getImageData(url: url) { data, _ in
                guard let data = data else {
                    return
                }
                if let image = UIImage(data: data) {
                    UIImageView.imageCache.store(value: image, forKey: url)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }

    }
}

//class ImageManager {
//
//    let imageCache = ImageCache()
//
//    func cacheImage(url: String, completion: @escaping (UIImage) -> Void) {
//
//        if let image = imageCache.retrieve(forKey: url) {
//            print(url)
//            completion(image)
//            return
//        }
//
//        DispatchQueue.global().async {
//            ShoppingNetworkManager.shared.getImageData(url: url) { data, _ in
//                guard let data = data else {
//                    return
//                }
//                if let image = UIImage(data: data) {
//                    self.imageCache.store(value: image, forKey: url)
//                    completion(image)
//                }
//            }
//        }
//    }
//
//}

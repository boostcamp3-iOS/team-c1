//
//  ImageManager.swift
//  CoCo
//
//  Created by 이호찬 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
import CoreGraphics
import Darwin

extension UIImage {
    func resize(scale: CGFloat) -> UIImage {
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let size = self.size.applying(transform)
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage!
    }
}

extension UIImageView {
    func setImage(url: String, isDisk: Bool = false) {
        ImageManager.shared.cacheImage(url: url, isDisk: isDisk) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

class ImageManager {

    static let shared = ImageManager()
    let imageCache = ImageCache()

    func cacheImage(url: String, isDisk: Bool, completion: @escaping (UIImage) -> Void) {

        if let image = imageCache.retrieve(forKey: url) {
            completion(image)
            return
        }
        ShoppingNetworkManager.shared.getImageData(url: url) { data, _ in
            guard let data = data else {
                return
            }
            if let image = UIImage(data: data) {
                self.imageCache.store(value: image, forKey: url, isDisk: isDisk)
                completion(image)
            }
        }
    }
}

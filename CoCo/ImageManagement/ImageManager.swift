//
//  ImageManager.swift
//  CoCo
//
//  Created by 이호찬 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width  / self.size.width
        let heightRatio = size.height / self.size.height
        let scale = widthRatio > heightRatio ? heightRatio : widthRatio
        let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = true
        format.scale = self.scale

        let render = UIGraphicsImageRenderer(size: size, format: format)
        let image = render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }

        return image
    }
}

extension UIImageView {
    func setImage(url: String, isDisk: Bool = false) {
        ImageManager.shared.cacheImage(url: url, isDisk: isDisk) { [weak self] image in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: { self.image = image }, completion: nil)
            }
        }
    }
}

class ImageManager {

    static let shared = ImageManager()
    let imageCache = ImageCache()

    private init() {

    }

    func cacheImage(url: String, isDisk: Bool, completion: @escaping (UIImage) -> Void) {

        if let image = imageCache.retrieve(forKey: url) {
            completion(image)
            return
        }
        ShoppingNetworkManager.shared.getImageData(url: url) { [weak self] data, _ in
            guard let self = self else {
                return
            }
            guard let data = data else {
                return
            }
            if let image = UIImage(data: data)?.resize(size: CGSize(width: 200, height: 200)) {
                self.imageCache.store(value: image, forKey: url, isDisk: isDisk)
                completion(image)
            }
        }
    }

    func removeAll() {
        imageCache.removeAll()
    }

    func getCacheSize() -> Int {
        return imageCache.getCacheSize()
    }
}

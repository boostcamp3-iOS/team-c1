//
//  CustomUIImageView.swift
//  CoCo
//
//  Created by 이호찬 on 21/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

class CustomUIImageView: UIImageView {
    var imageURLString: String?

    func setImage(urlString: String, isDisk: Bool = false) {
        if imageURLString ?? "" != urlString {
            if let task = ShoppingNetworkManager.shared.tasks[imageURLString ?? ""] {
                task.cancel()
            }
        }
        imageURLString = urlString
        ImageManager.shared.cacheImage(url: urlString, isDisk: isDisk) { [weak self] image in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: { self.image = image }, completion: nil)
            }
        }
    }
}

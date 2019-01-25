//
//  UIViewController+Alert.swift
//  CoCo
//
//  Created by 최영준 on 25/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

extension UIViewController {
    /// UIAlertController 간편 메서드, Main thread에서 동작한다.
    func alert(_ message: String, completaionHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel) { _ in
                completaionHandler?()
            }
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}

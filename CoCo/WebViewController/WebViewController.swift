//
//  WebViewController.swift
//  CoCo
//
//  Created by 최영준 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
}

// MARK: - ErrorHandlerType
extension WebViewController: ErrorHandlerType {
    func getErrorMessage(_ error: ErrorType) -> String {
        guard let webVCError = error as? WebViewControllerError else {
            return error.unknownError
        }
        return webVCError.rawValue
    }
}

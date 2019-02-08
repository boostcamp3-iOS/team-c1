//
//  ErrorHandlerType.swift
//  CoCo
//
//  Created by 최영준 on 08/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

protocol ErrorHandlerType {
    func getErrorMessage(_ error: ErrorType) -> String
}

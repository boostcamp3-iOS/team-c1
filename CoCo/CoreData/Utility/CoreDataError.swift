//
//  CoreDataError.swift
//  CoCo
//
//  Created by 강준영 on 28/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

enum CoreDataError: Error {
    case insert(message: String)
    case update(message: String)
    case delete(message: String)
    case fetch(message: String)
    case notFoundEntity(message: String)
}

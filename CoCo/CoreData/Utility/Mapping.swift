//
//  Mapping.swift
//  CoCo
//
//  Created by 강준영 on 08/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

protocol Mapping {
    mutating func mappinng(from: NSManagedObject)
    func mappinng(to: NSManagedObject)
}

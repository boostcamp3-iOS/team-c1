//
//  CoreDataStack.swift
//  CoCo
//
//  Created by 강준영 on 17/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataStack {
    static let shared = CoreDataStack()
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoCo")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Loading of store fail: \(error)")
            }
        })
        return container
    }()
}

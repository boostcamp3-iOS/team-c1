//
//  CoreDataManager.swift
//  CoCo
//
//  Created by 강준영 on 31/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
import CoreData

// MARK: - CoreDataManagerFunctionImplementType
protocol CoreDataManagerFunctionImplementType {
    var appDelegate: AppDelegate? { get }
    var context: NSManagedObjectContext? { get }
    func afterOperation(context: NSManagedObjectContext?)
}

extension CoreDataManagerFunctionImplementType {
    //Define default properties
    weak var appDelegate: AppDelegate? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate
    }
    var context: NSManagedObjectContext? {
        return appDelegate?.persistentContainer.viewContext
    }
}

extension CoreDataManagerFunctionImplementType {
    // MARK: - Util Method
    /**
     코어데이터 연산 후 데이터들이 반영되거나 수정되기전 상태로 돌아가게 하는 메서드
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
        - context: managedObject를 create, fetch, save할 때 사용되는 객체
     */
    func afterOperation(context: NSManagedObjectContext?) {
        guard let context = context else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
}

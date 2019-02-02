//
//  CoreDataManager.swift
//  CoCo
//
//  Created by 강준영 on 31/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataManagerFunctionImplementType {
    // MARK: - Properties
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
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let context = appdelegate.persistentContainer.viewContext
        return context
    }
}

extension CoreDataManagerFunctionImplementType {
    // MARK: - Util Method
    // 데이터의 연산결과가 반영되게 하는 함수
    func afterOperation(context: NSManagedObjectContext?) {
        guard let context = context else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
}

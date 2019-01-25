//
//  CoreDataManager.swift
//  CoCo
//
//  Created by 강준영 on 25/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    // MARK: - Properties
    static let shared = CoreDataManager()
    private weak var appDelegate: AppDelegate? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate
    }()
    private let context: NSManagedObjectContext? = {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let context = appdelegate.persistentContainer.viewContext
        return context
    }()

    // MARK: - Method
    // MARL: - CoreData Func
    func createKeywordsData(userPet: String, favoriteKeyword: [String]) {
        // MAKR: - Properties
        let userFavoriteInfo = FavoriteKeywordsData(pet: userPet, keywords: favoriteKeyword)
        guard let appDelegate = appDelegate else {
            return
        }
        guard let context = context else {
            return
        }

        let favoriteKeywords = FavoriteKeywords(context: context)
        favoriteKeywords.pet = userFavoriteInfo.pet
        favoriteKeywords.keywords = userFavoriteInfo.keywords as NSObject
        appDelegate.saveContext()

        print(favoriteKeywords)
    }

}

//
//  CommonCoreDataManager.swift
//  CoCo
//
//  Created by 강준영 on 23/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
import CoreData

struct CommonCoreDataManager: CommonCoreDataManagerType, CoreDataManagerFunctionImplementType {

    /**
     MyGoods Entity에 데이터 삽입.
     - Author: [강준영](https://github.com/lavaKangJun)
     - Parameter :
     - coreDataStructType: coreDataStructType 프로토콜을 채택하는 CoreData Struct.
     */
    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T, comepletion: @escaping (Bool, Error?) -> Void) {
        guard let container = container else {
            return
        }
        switch coreDataStructType {
        case is MyGoodsData:
            guard var myGoodsData = coreDataStructType as? MyGoodsData else {
                return
            }
            // 삽입하려는 데이터와 동일한 productID가 존재하면 기존 데이터 업데이트
            MyGoodsCoreDataManager(commonCoreDataManagerType:
                self).fetchProductID(productID: myGoodsData.productID) {
                    (object, _) in
                    if let object = object {
                        myGoodsData.objectID = object.objectID
                        self.updateObject(myGoodsData) { (isSuccess) in
                            if isSuccess {
                                comepletion(true, nil)
                            } else {
                                comepletion(false, nil)
                            }
                        }
                        // 삽입하려는 데이터와 동일한 데이터가 MyGoods Entity에 존재하는 지 확인하기 위해 삽입하려는 데이터의 productID를 Entity에 존재하는 지 확인.
                        // 삽입하려는 데이터의 productID와 동일한 데이터가 없는 경우 삽입을 진행
                    } else {
                        container.performBackgroundTask { (context) in
                            let myGoods = MyGoods(context: context)
                            myGoodsData.mappinng(to: myGoods)
                            self.afterOperation(context: context)
                            comepletion(true, nil)
                        }
                    }
            }
        case is PetKeywordData:

            guard var petKeywordData = coreDataStructType as? PetKeywordData else {
                return
            }
            // PetKeyword Entity는 동물별로 데이터가 하나만 존재해야하기 때문에 데이터가 존재하는 지 확인
            PetKeywordCoreDataManager().fetchObjects(pet: petKeywordData.pet) { (objects, _) in
                if var object = objects?.first {
                    petKeywordData.objectID = object.objectID
                    self.updateObject(petKeywordData) { (isSuccess) in
                        if isSuccess {
                            comepletion(true, nil)
                        } else {
                            comepletion(false, nil)
                        }
                    }
                }
                    // 존재하지 않는 경우 데이터 삽입
                else {
                    container.performBackgroundTask { (context) in
                        let petKeyword = PetKeyword(context: context)
                        petKeywordData.mappinng(to: petKeyword)
                        self.afterOperation(context: context)
                        comepletion(true, nil)
                    }
                }
            }
        case is SearchWordData:
            guard var searchKeywordData = coreDataStructType as? SearchWordData else {
                return
            }
            guard let pet = searchKeywordData.pet else {
                return
            }
            // SearchKeyword Entity에 검색에가 존재하는 지 확인
            // 검색어가 존재하면 업데이트
            SearchWordCoreDataManager().fetchWord(searchKeywordData.searchWord, pet: pet) { (object) in
                if let object = object {
                    searchKeywordData.objectID = object.objectID
                    self.updateObject(searchKeywordData) { (isSuccess) in
                        if isSuccess {
                            comepletion(true, nil)
                        } else {
                            comepletion(false, nil)
                        }
                    }
                    // 존재하지 않으면 검색어 데이터 추가
                } else {
                    container.performBackgroundTask { (context) in
                        let searchKeyword = SearchWord(context: context)
                        searchKeywordData.mappinng(to: searchKeyword)
                        self.afterOperation(context: context)
                        comepletion(true, nil)
                    }
                }
            }

        default:
            comepletion(false, nil)
        }
    }

    func updateObject<T>(_ coreDataStructType: T, completion: @escaping (Bool) -> Void) {
        guard let container = container else {
            return
        }
        switch coreDataStructType {
        case is MyGoodsData:
            container.performBackgroundTask { (context) in
                guard let myGoodsData = coreDataStructType as? MyGoodsData else {
                    return
                }
                guard let objectID = myGoodsData.objectID else {
                    return
                }
                guard let object = context.object(with: objectID) as? MyGoods
                    else {
                        return
                }
                myGoodsData.mappinng(to: object)
                self.afterOperation(context: context)
                completion(true)
            }
        case is PetKeywordData:
            container.performBackgroundTask { (context) in
                guard let petKeywordData = coreDataStructType as? PetKeywordData else {
                    return
                }
                guard let objectID = petKeywordData.objectID else {
                    return
                }
                guard let object = context.object(with: objectID) as? PetKeyword else {
                    return
                }
                petKeywordData.mappinng(to: object)
                self.afterOperation(context: context)
                completion(true)
            }
        case is SearchWordData:
            container.performBackgroundTask { (context) in
                guard let searchWordData = coreDataStructType as? SearchWordData else {
                    return
                }
                guard let objectID = searchWordData.objectID else {
                    return
                }
                guard let object = context.object(with: objectID) as? SearchWord else {
                    return
                }
                searchWordData.mappinng(to: object)
                self.afterOperation(context: context)
                completion(true)
            }
        default:
            completion(false)
        }
    }

    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T, completion: @escaping (Bool) -> Void) {
        guard let container = container else {
            return
        }
        switch coreDataStructType {
        case is MyGoodsData:
            container.performBackgroundTask { (context) in
                guard let object = coreDataStructType as? MyGoodsData else {
                    return
                }
                if let objectID = object.objectID {
                    let deleteObjet = context.object(with: objectID)
                    context.delete(deleteObjet)
                    self.afterOperation(context: context)
                    completion(true)
                }
            }
        case is PetKeywordData:
            container.performBackgroundTask { (context) in
                guard let petKeywordData = coreDataStructType as? PetKeywordData else {
                    return
                }
                if let objectID = petKeywordData.objectID {
                    let object = context.object(with: objectID)
                    context.delete(object)
                    self.afterOperation(context: context)
                    completion(true)
                }
            }
        case is SearchWordData:
            container.performBackgroundTask { (context) in
                guard let searchKeywordData = coreDataStructType as? SearchWordData else {
                    return
                }
                if let objectID = searchKeywordData.objectID {
                    let object = context.object(with: objectID)
                    context.delete(object)
                    self.afterOperation(context: context)
                    completion(true)
                }
            }
        default:
            completion(false)
        }
    }
}

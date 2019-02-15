//
//  WebViewService.swift
//  CoCo
//
//  Created by 최영준 on 13/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

/*
 필요한 기능:
 - 데이터 업데이트(찜 여부에 따라 isFavorite 변경한 후 저장)
 필요한 변수:
 - MyGoodsCoreDataManager
    -- updateObject(_:)
 - MyGoodsData
 */

/**
 WebViewConroller에서 사용되는 비즈니스 모델을 처리한다.
 
 사용자의 찜 선택 여부에 따른 변경사항을 CoreData에 저장한다.
 
 MyGoodsData와 함께 초기화, MyGoodsData 프로퍼티에 접근하여 데이터 변경
 ```
 init(data: MyGoodsData)
 var myGoodsData: MyGoodsData
 ```
 변경 내역을 CoreData에 저장
 ```
 func updateObject() -> Bool
 ```
 - Author: [최영준](https://github.com/0jun0815)
 */
class WebViewService {
    // MARK: - Data
    private(set) var myGoodsData: MyGoodsData

    // MARK: - Manager
    private lazy var manager = MyGoodsCoreDataManager()

    // MARK: - Initializer
    init(data: MyGoodsData) {
        myGoodsData = data
    }

    // MARK: - Public methods
    @discardableResult func insert() -> Bool {
        myGoodsData.isLatest = true
        myGoodsData.date = myGoodsData.createDate()
        // 이미 같은 productID의 상품이 존재한다면 manager 내부에서 update를 호출함
        let result = try? manager.insert(myGoodsData)
        if let result = result {
            return result
        }
        return false
    }

    func updateFavorite(_ isFavorite: Bool) {
        myGoodsData.isFavorite = isFavorite
        // 이미 같은 productID의 상품이 존재한다면 manager 내부에서 update를 호출함
        insert()
    }
}

//
//  WebViewService.swift
//  CoCo
//
//  Created by 최영준 on 13/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

/**
 WebViewConroller에서 사용되는 비즈니스 모델을 처리한다.
 
 최근 본 상품을 CoreData에 추가하며 사용자의 찜 선택 여부에 따른 변경사항을 CoreData에 저장한다.
 
 MyGoodsData와 함께 초기화한다.
 ```
 init(data: MyGoodsData)
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
    /// MyGoodsData를 코어 데이터에 저장(또는 업데이트)한다.
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
    /// preductID로 이미 코어데이터에 저장된 데이터인지 확인한다.
    func fetchData() {
        if let data = manager.fetchProductID(productID: myGoodsData.productID) {
            var newData = MyGoodsData()
            newData.mappinng(from: data)
            myGoodsData = newData
        }
    }
    /// 상품의 좋아요(찜) 변경을 반영한다.
    func updateFavorite(_ isFavorite: Bool) {
        if isFavorite { myGoodsData.isLatest = false }
        myGoodsData.isFavorite = isFavorite
        // 이미 같은 productID의 상품이 존재한다면 manager 내부에서 update를 호출함
        insert()
    }
}

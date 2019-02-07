//
//  MyGoodsDummy.swift
//  CoCo
//
//  Created by 강준영 on 07/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

struct MyGoodsDummy {
    var dummyArray = [MyGoodsData]()
    
    init() {
        var myGoods1 = MyGoodsData()
        myGoods1.title = "고양이 방석"
        myGoods1.image = ""
        myGoods1.isFavorite = false
        myGoods1.isLatest = true
        myGoods1.link = ""
        myGoods1.pet = "고양이"
        myGoods1.price = "1500"
        myGoods1.productId = "11111"
        myGoods1.shoppingmall = "마루"
        myGoods1.date = "2018-01-11"
        
        var myGoods2 = MyGoodsData()
        myGoods2.title = "고양이 의자"
        myGoods2.image = ""
        myGoods2.isFavorite = false
        myGoods2.isLatest = true
        myGoods2.link = ""
        myGoods2.pet = "고양이"
        myGoods2.price = "1500"
        myGoods2.productId = "22222"
        myGoods2.shoppingmall = "마루"
        myGoods2.date = "2018-02-11"
        
        var myGoods3 = MyGoodsData()
        myGoods3.title = "고양이 방석"
        myGoods3.image = ""
        myGoods3.isFavorite = false
        myGoods3.isLatest = true
        myGoods3.link = ""
        myGoods3.pet = "고양이"
        myGoods3.price = "1500"
        myGoods3.productId = "33333"
        myGoods3.shoppingmall = "마루"
        myGoods3.date = "2018-03-11"
        
        var myGoods4 = MyGoodsData()
        myGoods4.title = "고양이 사료"
        myGoods4.image = ""
        myGoods4.isFavorite = false
        myGoods4.isLatest = true
        myGoods4.link = ""
        myGoods4.pet = "고양이"
        myGoods4.price = "1500"
        myGoods4.productId = "44444"
        myGoods4.shoppingmall = "마루"
        myGoods4.date = "2018-04-11"
        
        var myGoods5 = MyGoodsData()
        myGoods5.title = "고양이 간식"
        myGoods5.image = ""
        myGoods5.isFavorite = false
        myGoods5.isLatest = true
        myGoods5.link = ""
        myGoods5.pet = "고양이"
        myGoods5.price = "1500"
        myGoods5.productId = "55555"
        myGoods5.shoppingmall = "마루"
        myGoods5.date = "2018-05-11"
        
        var myGoods6 = MyGoodsData()
        myGoods6.title = "고양이 집"
        myGoods6.image = ""
        myGoods6.isFavorite = false
        myGoods6.isLatest = true
        myGoods6.link = ""
        myGoods6.pet = "고양이"
        myGoods6.price = "1500"
        myGoods6.productId = "66666"
        myGoods6.shoppingmall = "마루"
        myGoods6.date = "2018-06-11"
        
        var myGoods7 = MyGoodsData()
        myGoods7.title = "고양이 방석"
        myGoods7.image = ""
        myGoods7.isFavorite = false
        myGoods7.isLatest = true
        myGoods7.link = ""
        myGoods7.pet = "고양이"
        myGoods7.price = "1500"
        myGoods7.productId = "77777"
        myGoods7.shoppingmall = "마루"
        myGoods7.date = "2018-07-11"
        
        var myGoods8 = MyGoodsData()
        myGoods8.title = "고양이 과자"
        myGoods8.image = ""
        myGoods8.isFavorite = false
        myGoods8.isLatest = true
        myGoods8.link = ""
        myGoods8.pet = "고양이"
        myGoods8.price = "1500"
        myGoods8.productId = "88888"
        myGoods8.shoppingmall = "마루"
        myGoods8.date = "2018-08-11"
        
        var myGoods9 = MyGoodsData()
        myGoods9.title = "고양이 장난감"
        myGoods9.image = ""
        myGoods9.isFavorite = false
        myGoods9.isLatest = true
        myGoods9.link = ""
        myGoods9.pet = "고양이"
        myGoods9.price = "1500"
        myGoods9.productId = "99999"
        myGoods9.shoppingmall = "마루"
        myGoods9.date = "2018-09-11"
        
        var myGoods10 = MyGoodsData()
        myGoods10.title = "고양이 캣타워"
        myGoods10.image = ""
        myGoods10.isFavorite = false
        myGoods10.isLatest = true
        myGoods10.link = ""
        myGoods10.pet = "고양이"
        myGoods10.price = "1500"
        myGoods10.productId = "1010101010"
        myGoods10.shoppingmall = "마루"
        myGoods10.date = "2018-10-11"
        
        var myGoods11 = MyGoodsData()
        myGoods11.title = "고양이 식기"
        myGoods11.image = ""
        myGoods11.isFavorite = true
        myGoods11.isLatest = true
        myGoods11.link = ""
        myGoods11.pet = "고양이"
        myGoods11.price = "1500"
        myGoods11.productId = "11111111"
        myGoods11.shoppingmall = "마루"
        myGoods11.date = "2018-11-11"
        
        var myGoods12 = MyGoodsData()
        myGoods12.title = "고양이 물통"
        myGoods12.image = ""
        myGoods12.isFavorite = false
        myGoods12.isLatest = true
        myGoods12.link = ""
        myGoods12.pet = "고양이"
        myGoods12.price = "1500"
        myGoods12.productId = "1212121212"
        myGoods12.shoppingmall = "마루"
        myGoods12.date = "2018-12-11"
        
        dummyArray.append(myGoods1)
        dummyArray.append(myGoods2)
        dummyArray.append(myGoods3)
        dummyArray.append(myGoods4)
        dummyArray.append(myGoods5)
        dummyArray.append(myGoods6)
        dummyArray.append(myGoods7)
        dummyArray.append(myGoods8)
        dummyArray.append(myGoods9)
        dummyArray.append(myGoods10)
        dummyArray.append(myGoods11)
        dummyArray.append(myGoods12)
    }
}

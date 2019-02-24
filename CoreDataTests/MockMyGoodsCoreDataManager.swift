//
//  Mock.swift
//  CoreDataTests
//
//  Created by 강준영 on 24/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation
@testable import CoCo

class MockMyGoodsCoreDataManager: MyGoodsCoreDataManagerType {

    func fetchObjects(pet: String?, completion: @escaping ([CoreDataStructEntity]?, Error?) -> Void) throws {
        if let pet = pet {
            if pet == "고양이" || pet == "강아지" {
                completion([MyGoodsData(pet: pet, title: "강아지간식", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "66666", searchWord: "푸드", shoppingmall: "네이버")], nil)
            }
        } else {
            completion([MyGoodsData(pet: "고양이", title: "강아지간식", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "66666", searchWord: "푸드", shoppingmall: "네이버"), MyGoodsData(pet: "강아지", title: "강아지간식", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "66666", searchWord: "푸드", shoppingmall: "네이버")], nil)
        }
    }
    
    func fetchFavoriteGoods(pet: String?, completion: @escaping ([MyGoodsData]?, Error?) -> Void) {
        
        if let pet = pet {
            completion([MyGoodsData(pet: pet, title: "강아지옷", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "12345", searchWord: "뷰티", shoppingmall: "네이버")], nil)
        } else {
            completion([MyGoodsData(pet: "강아지", title: "강아지옷", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "999999", searchWord: "뷰티", shoppingmall: "네이버"), MyGoodsData(pet: "고양이", title: "고양이옷", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "55555", searchWord: "뷰티", shoppingmall: "네이버")], nil)
        }
    }
    
    func fetchLatestGoods(pet: String?, isLatest: Bool, ascending: Bool, completion: @escaping ([MyGoodsData]?, Error?) -> Void) {
        if let pet = pet {
            completion([MyGoodsData(pet: pet, title: "강아지샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "54321", searchWord: "뷰티", shoppingmall: "네이버")], nil)
        } else {
            completion([MyGoodsData(pet: "고양이", title: "고양이샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "9875", searchWord: "뷰티", shoppingmall: "네이버"), MyGoodsData(pet: "강아지", title: "강아지샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "58765", searchWord: "뷰티", shoppingmall: "네이버")], nil)
        }
    }
    
    func fetchProductID(productID: String, completion: @escaping (MyGoods?, Error?) -> Void) {
        
    }
    
    func deleteFavoriteAllObjects(pet: String, completion: @escaping (Bool, Error?) -> Void) {
        
    }
    
    func deleteLatestAllObjects(pet: String, isLatest: Bool, completion: @escaping (Bool, Error?) -> Void) {
        if pet == "고양이" || pet == "강아지" {
           completion(true, nil)
        } else {
            completion(false, nil)
        }
    }
    func latestGoodsToFalse(pet: String, completion: @escaping (Error?) -> Void) {
        
    }
}

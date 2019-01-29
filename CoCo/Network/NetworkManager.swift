//
//  NetworkManager.swift
//  CoCo
//
//  Created by 이호찬 on 25/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

enum SortOption: String {
    case similar = "sim"
    case date = "date"
    case ascending = "asc"
    case descending = "dsc"
}

protocol NetworkManagerType {

    associatedtype Params

    func getAPIData(_ params: Params, completion: @escaping (APIResponseShoppingData) -> Void)

    init(headerDic: [String: String], host: String)
}

extension NetworkManagerType {
    fileprivate func dispatchAPI(in dispatcher: Dispatcher, request: APIRequest, completion: @escaping (Data) -> Void) {
        do {
            try dispatcher.execute(request: request) { response in
                completion(response)
            }
        } catch let error {
            print(error)
        }
    }
}

class ShoppingNetworkManager: NetworkManagerType {

    typealias Params = Parameters

    struct Parameters {
        var search: String
        var count: Int = 10
        var start: Int = 1
        var sort: SortOption = .similar
    }

    // MARK: - Private Properties
    private var environment: Environment

    // MARK: - Initializer
    required init(headerDic: [String: String], host: String) {
        self.environment = Environment(host: host, headerDic: headerDic)

    }

    // MARK: - Methods
    func getAPIData(_ params: ShoppingNetworkManager.Parameters, completion: @escaping (APIResponseShoppingData) -> Void) {
        let dispatcher = NetworkDispatcher(environment: environment).makeNetworkProvider()
        let responseAPI = ResponseAPI()
        let request = APIRequest.getShoppingAPI(query: params.search, display: params.count, start: params.start, sort: params.sort)

        dispatchAPI(in: dispatcher, request: request) { data in
            responseAPI.parse(data: data, completion: completion)
        }
    }
}

// MockData
class MockNetworkManager: NetworkManagerType {

    typealias Params = String?

    let mockData: String = """
    {
    "lastBuildDate": "Mon, 28 Jan 2019 20:25:32 +0900",
    "total": 825811,
    "start": 1,
    "display": 10,
    "items": [
    {
    "title": "편안한 <b>강아지옷</b>",
    "link": "http://search.shopping.naver.com/gate.nhn?id=12266356584",
    "image": "https://shopping-phinf.pstatic.net/main_1226635/12266356584.8.jpg",
    "lprice": "7900",
    "hprice": "0",
    "mallName": "울리",
    "productId": "12266356584",
    "productType": "2"

    },
    {
    "title": "뼈디다스 올린원 <b>강아지옷</b>",
    "link": "http://search.shopping.naver.com/gate.nhn?id=17169947465",
    "image": "https://shopping-phinf.pstatic.net/main_1716994/17169947465.20190123174005.jpg",
    "lprice": "4900",
    "hprice": "6800",
    "mallName": "네이버",
    "productId": "17169947465",
    "productType": "1"

    },
    {
    "title": "몰래펫 <b>강아지옷</b> 애견옷 애견의류 12종 강아지패딩 강아지겨울옷 강아지올인원 강아지티셔츠",
    "link": "http://search.shopping.naver.com/gate.nhn?id=81570128324",
    "image": "https://shopping-phinf.pstatic.net/main_8157012/81570128324.1.jpg",
    "lprice": "6700",
    "hprice": "0",
    "mallName": "몰래펫샵",
    "productId": "81570128324",
    "productType": "2"

    }]}
"""

    required init(headerDic: [String: String], host: String) {
        print("mockData")
    }

    func getAPIData(_ params: String?, completion: @escaping (APIResponseShoppingData) -> Void) {
        let data = Data(mockData.utf8)
        let responseAPI = ResponseAPI()
        responseAPI.parse(data: data, completion: completion)
    }
}

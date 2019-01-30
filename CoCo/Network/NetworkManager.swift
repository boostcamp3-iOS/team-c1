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

    func getAPIData(_ params: Params, completion: @escaping (APIResponseShoppingData) -> Void, errorHandler: @escaping () -> Void)
    init()
}

extension NetworkManagerType {
    fileprivate func dispatchAPI(in dispatcher: Dispatcher, request: APIRequest, completion: @escaping (Data) -> Void) throws {
        do {
            try dispatcher.execute(request: request) { response in
                completion(response)
            }
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

        init(search: String) {
            self.search = search
        }
    }

    // MARK: - Private Properties
    private let host = "https://openapi.naver.com/v1/search/shop.json?"
    private let headerDic = ["X-Naver-Client-Id": "qHtcfM1UHhWZXTx9mwYI", "X-Naver-Client-Secret": "HRzkmrNKSs"]
    private var environment: Environment

    // MARK: - Initializer
    required init() {
         self.environment = Environment(host: host, headerDic: headerDic)
    }

    // MARK: - Methods
    func getAPIData(_ params: ShoppingNetworkManager.Parameters, completion: @escaping (APIResponseShoppingData) -> Void, errorHandler: @escaping () -> Void) {
        let dispatcher = NetworkDispatcher(environment: environment).makeNetworkProvider()
        let responseAPI = ResponseAPI()
        let request = APIRequest.getShoppingAPI(query: params.search, display: params.count, start: params.start, sort: params.sort)
        do {
            try dispatchAPI(in: dispatcher, request: request) { data in
                do {
                    try responseAPI.parse(data: data, completion: completion)
                } catch let err {
                    print(err)
                    errorHandler()
                }
            }
        } catch let err {
            print(err)
            errorHandler()
        }
    }

    /* 호출 예시
     
     let shoppingAPI = ShoppingNetworkManager()
     let param = ShoppingNetworkManager.Parameters(search: "강아지 옷")
     shoppingAPI.getAPIData(param, completion: { data in
     print(data)
     }) {
     print("error")
     }
 
     */
}

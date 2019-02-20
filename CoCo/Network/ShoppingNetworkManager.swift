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

struct ShoppingParams {
    // MARK: - Properties
    var search: String
    var count: Int = 10
    var start: Int = 1
    var sort: SortOption = .similar

    // MARK: - Initializer
    init(search: String) {
        self.search = search
    }

    init(search: String, count: Int, start: Int, sort: SortOption) {
        self.search = search
        self.count = count
        self.start = start
        self.sort = sort
    }
}

class ShoppingNetworkManager: NetworkManagerType {
    // MARK: - Private Properties
    private let host = "https://openapi.naver.com/v1/search/shop.json?"
    lazy private var environment = Environment(host: host)

    // MARK: - Initializer
    static let shared = ShoppingNetworkManager()
    private init() { }

    // MARK: - Methods
    /**
     API 데이터를 서버에 요청하고 가져온다.
     
     - Author: [이호찬](https://github.com/LHOCHAN)
     - Parameters:
        - params: 서버에 넘겨줄 파라미터
        - completion: 서버에서 데이터를 받아와 성공적으로 파싱까지 완료 했을경우 호출된다.
        - errorHandler: 함수를 실행하는중 에러가 발생했을 경우 호출된다.
     */
    func getAPIData(_ params: ShoppingParams, completion: @escaping (APIResponseShoppingData) -> Void, errorHandler: @escaping (Error) -> Void) {
        let dispatcher = NetworkDispatcher(environment: environment).makeNetworkProvider()
        let responseAPI = ResponseAPI()
        let request = APIRequest.requestShoppingAPI(query: params.search, display: params.count, start: params.start, sort: params.sort)
        do {
            try dispatchAPI(in: dispatcher, request: request) { data in
                do {
                    try responseAPI.parse(data: data, completion: completion)
                } catch let err {
                    errorHandler(err)
                }
            }
        } catch let err {
            errorHandler(err)
        }
    }

    func getImageData(url: String, completion: @escaping (Data?, Error?) -> Void) {
        let environment = Environment(host: url)
        let dispatcher = NetworkDispatcher(environment: environment).makeNetworkProvider()
        let request = APIRequest.requestAPI()
        do {
            try dispatchAPI(in: dispatcher, request: request) { data in
                completion(data, nil)
            }
        } catch let err {
            completion(nil, err)
        }
    }
    
    func cancelImageData(url: String) {
        
    }
}

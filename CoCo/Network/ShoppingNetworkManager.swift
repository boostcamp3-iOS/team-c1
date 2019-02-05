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
}

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

class NetworkManager {

    static let shared: NetworkManager = NetworkManager()

    // MARK: - Private Properties

    private let headers =  ["X-Naver-Client-Secret": "HRzkmrNKSs", "X-Naver-Client-Id": "qHtcfM1UHhWZXTx9mwYI"]
    private let host = "https://openapi.naver.com/v1/search/shop.json?"

    // MARK: - Methods

    func getShoppingData(search query: String, count display: Int, start: Int, sort: SortOption, completion: @escaping (APIResponseShoppingData) -> Void) {

        let enviroment = Environment(host: host, headers: headers)
        let dispatcher = NetworkDispatcher.init(environment: enviroment).makeNetworkProvider()
        let responseAPI = ResponseAPI()
        let request = APIRequest.getShopingAPI(query: query, display: display, start: start, sort: sort)

        dispatchAPI(in: dispatcher, request: request) { data in
            responseAPI.parse(data: data, completion: completion)
        }
    }

    // MARK: - Private Methods

    private func dispatchAPI(in dispatcher: Dispatcher, request: APIRequest, completion: @escaping (Data) -> Void) {
        do {
            try dispatcher.execute(request: request) { response in
                completion(response)
            }
        } catch let error {
            print(error)
        }
    }

}

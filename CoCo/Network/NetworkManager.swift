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

typealias Parameters = (query: String, display: Int, start: Int, sort: SortOption)
typealias HTTPHeaders = [String: String]

class NetworkManager {
    // MARK: - Properties

    static let shared = NetworkManager()

    // MARK: - Methods

    func getData(parameters: Parameters, completion: @escaping (APIResponseShoppingData) -> Void, errorHandler: @escaping () -> Void) {
        guard let urlRequset = makeURLRequest(parameters: parameters) else { return }
        Request().request(url: urlRequset, completion: completion, errorHandler: errorHandler)
    }

    private func makeURLRequest(parameters: Parameters) -> URLRequest? {
        let bodyURL = "https://openapi.naver.com/v1/search/shop.json?"
        let headers: HTTPHeaders = ["X-Naver-Client-Secret": "HRzkmrNKSs", "X-Naver-Client-Id": "qHtcfM1UHhWZXTx9mwYI"]
        let urlString = bodyURL + "query=\(parameters.query)" + "&display=\(parameters.display)" + "&start=\(parameters.start)" + "&sort=\(parameters.sort)"

        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return nil }

        let urlRequest: URLRequest = URLRequest(url: url)

        return setHTTPHeader(urlRequest: urlRequest, headers: headers)
    }

    private func setHTTPHeader(urlRequest: URLRequest, headers: HTTPHeaders) -> URLRequest {
        var urlRequest = urlRequest
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        return urlRequest
    }

}

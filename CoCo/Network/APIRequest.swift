//
//  APIRequest.swift
//  CoCo
//
//  Created by 이호찬 on 28/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

enum APIRequest {
    case getShopingAPI(query: String, display: Int, start: Int, sort: SortOption)
}

extension APIRequest: Request {
    // MARK: - Properties

    var path: String {
        switch self {
        case .getShopingAPI :
            return ""
        }
    }
    var method: HTTPMethod {
        switch self {
        case .getShopingAPI :
            return .get
        }
    }
    var parameters: RequestParams {
        switch self {
        case .getShopingAPI (let query, let display, let start, let sort):
            return .url(["query": query, "display": String(display), "start": String(start), "sort": sort.rawValue])
        }
    }
    var headers: [String: Any]? {
        switch self {
        case .getShopingAPI :
            return [:]
        }
    }

}

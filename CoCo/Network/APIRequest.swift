//
//  APIRequest.swift
//  CoCo
//
//  Created by 이호찬 on 28/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

enum APIRequest {
    case getShoppingAPI(query: String, display: Int, start: Int, sort: SortOption)
}

extension APIRequest: Request {

    // MARK: - Properties
    var path: String {
        switch self {
        case .getShoppingAPI :
            return ""
        }
    }
    var method: HTTPMethod {
        switch self {
        case .getShoppingAPI :
            return .get
        }
    }
    var parameters: RequestParams {
        switch self {
        case .getShoppingAPI (let query, let display, let start, let sort):
            return .url(["query": query, "display": "\(display)", "start": "\(start)", "sort": sort.rawValue])
        }
    }
    var headerDic: [String: Any]? {
        switch self {
        case .getShoppingAPI :
            return [:]
        }
    }
}
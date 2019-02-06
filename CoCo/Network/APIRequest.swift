//
//  APIRequest.swift
//  CoCo
//
//  Created by 이호찬 on 28/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

enum APIRequest {
    case requestShoppingAPI(query: String, display: Int, start: Int, sort: SortOption)
    case requestAPI()
}

extension APIRequest: Request {
    // MARK: - Properties
    var path: String? {
        switch self {
        case .requestShoppingAPI :
            return nil
        case .requestAPI :
            return nil
        }
    }
    var method: HTTPMethod {
        switch self {
        case .requestShoppingAPI :
            return .get
        case .requestAPI :
            return .get
        }
    }
    var parameters: RequestParams {
        switch self {
        case .requestShoppingAPI (let query, let display, let start, let sort):
            return .url(["query": query, "display": "\(display)", "start": "\(start)", "sort": sort.rawValue])
        case .requestAPI :
            return .url(nil)
        }
    }
    var headerDic: [String: Any]? {
        switch self {
        case .requestShoppingAPI :
            return ["X-Naver-Client-Id": "qHtcfM1UHhWZXTx9mwYI", "X-Naver-Client-Secret": "HRzkmrNKSs"]
        case .requestAPI :
            return nil
        }
    }
}

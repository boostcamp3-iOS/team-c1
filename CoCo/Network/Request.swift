//
//  Request.swift
//  CoCo
//
//  Created by 이호찬 on 25/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum RequestParams {
    case body(_ : [String: String]?)
    case url(_ : [String: String]?)
}

protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: RequestParams { get }
    var headerDic: [String: Any]? { get }
}

//
//  Response.swift
//  CoCo
//
//  Created by 이호찬 on 28/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

enum NetworkErrors: Error {
    case badInput
    case noData
    case invalidParams
    case invalidComponent
    case failParsing
}

protocol Response {
    func parse<T: Decodable>(data: Data, completion: (T) -> Void) throws
}

class ResponseAPI: Response {
    // MARK: - Methods
    func parse<T: Decodable>(data: Data, completion: (T) -> Void) throws {
        do {
            let apiResponse: T = try JSONDecoder().decode(T.self, from: data)
            completion(apiResponse)
        } catch {
            throw NetworkErrors.failParsing
        }
    }
}

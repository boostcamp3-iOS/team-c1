//
//  Response.swift
//  CoCo
//
//  Created by 이호찬 on 28/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

enum NetworkErrors: Error {
    // 에러 처리 하는걸 만들어야함
    case badInput
    case noData
    case withoutParams
    case invalidComponent
    case failParsing
}

protocol Response {
    func parse<T: Decodable>(data: Data, completion: (T) -> Void)
}

class ResponseAPI: Response {

    // MARK: - Methods
    func parse<T: Decodable>(data: Data, completion: (T) -> Void) {
        do {
            let apiResponse: T = try JSONDecoder().decode(T.self, from: data)
            completion(apiResponse)
        } catch let error {
            print(error.localizedDescription)
//            throw NetworkErrors.failParsing
        }
    }
}

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

protocol ResponseType {
    func parse<T: Decodable>(data: Data, completion: (T) -> Void) throws
}

class ResponseAPI: ResponseType {
    // MARK: - Methods
    /**
     JSON 데이터를 원하는 형식으로 파싱한다.
     
     - Author: [이호찬](https://github.com/LHOCHAN)
     - Parameters:
        - data: 서버에서 반환된 JSON 형식의 데이터
        - completion: 데이터를 성공적으로 파싱했을경우 호출된다.
     - Throws: failParsing 혹은 이전 함수에서 발생한 에러
     */
    func parse<T: Decodable>(data: Data, completion: (T) -> Void) throws {
        do {
            let apiResponse: T = try JSONDecoder().decode(T.self, from: data)
            completion(apiResponse)
        } catch {
            throw NetworkErrors.failParsing
        }
    }
}

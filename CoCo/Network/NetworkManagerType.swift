//
//  NetworkManagerType.swift
//  CoCo
//
//  Created by 이호찬 on 05/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

protocol NetworkManagerType {
    func getAPIData(_ params: ShoppingParams, completion: @escaping (APIResponseShoppingData) -> Void, errorHandler: @escaping (Error) -> Void)
}

extension NetworkManagerType {
    /**
     dispatcher를 통해 서버에 데이터를 요청한다.
     
     execute 함수를 실행
     - Author: [이호찬](https://github.com/LHOCHAN)
     - Parameters:
        - dispatcher: 서버에 데이터를 받아올 수 있는 함수가 정의된 프로토콜
        - request: path, method, parameter, header 등이 정의된 열거형
        - completion: 내부의 execute 함수가 성공적으로 실행됬을경우 호출된다.
     */
    func dispatchAPI(in dispatcher: Dispatcher, request: APIRequest, completion: @escaping (Data) -> Void) throws {
        try dispatcher.execute(request: request) { response in
            completion(response)
        }
    }
}

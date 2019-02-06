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
    func dispatchAPI(in dispatcher: Dispatcher, request: APIRequest, completion: @escaping (Data) -> Void) throws {
        try dispatcher.execute(request: request) { response in
            completion(response)
        }
    }
}

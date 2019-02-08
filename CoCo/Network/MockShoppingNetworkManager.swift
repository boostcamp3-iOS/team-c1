//
//  MockShoppingNetworkManager.swift
//  NetworkTests
//
//  Created by 이호찬 on 01/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

// MockData
class MockShoppingNetworkManager: NetworkManagerType {

    // MARK: - Initializer
    static let shared = MockShoppingNetworkManager()
    private init() { }

    // MARK: - Methods
    func getAPIData(_ params: ShoppingParams, completion: @escaping (APIResponseShoppingData) -> Void, errorHandler: @escaping (Error) -> Void) {
        let data = Data(MockShoppingNetworkManagerDummy.successDummyString.utf8)
        let responseAPI = ResponseAPI()
        do {
            try responseAPI.parse(data: data, completion: completion)
        } catch let err {
            print(err)
            errorHandler(err)
        }
    }
}

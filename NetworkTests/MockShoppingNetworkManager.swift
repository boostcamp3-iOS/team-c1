//
//  MockShoppingNetworkManager.swift
//  NetworkTests
//
//  Created by Leonard on 30/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

@testable import CoCo
import Foundation

// MockData
class MockShoppingNetworkManager: NetworkManagerType {
    typealias Params = String?

    // MARK: - Private Properties
    var mockData: String!

    // MARK: - Initializer
    required init() {
        print("mockData")
    }

    // MARK: - Methods
    func getAPIData(_ params: String?, completion: @escaping (APIResponseShoppingData) -> Void, errorHandler: @escaping () -> Void) {
        let data = Data(mockData.utf8)
        let responseAPI = ResponseAPI()
        do {
            try responseAPI.parse(data: data, completion: completion)
        } catch let err {
            print(err)
            errorHandler()
        }
    }
}

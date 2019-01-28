//
//  Dispatcher.swift
//  CoCo
//
//  Created by 이호찬 on 28/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

protocol Dispatcher {

    init(environment: Environment)

    func execute(request: Request, completion: @escaping (Data) -> Void) throws
}

class NetworkDispatcher {

    private var environment: Environment

    init(environment: Environment) {
        self.environment = environment
    }

    func makeNetworkProvider() -> Dispatcher {
        return NetworkDispatcher(environment: environment)
    }
}

private extension NetworkDispatcher {
    
    class NetworkDispatcher: Dispatcher {
        
        // MARK: - Properties
        
        let session: URLSession
        let environment: Environment
        
        // MARK: - Initializer
        
        required init(environment: Environment) {
            self.session = URLSession(configuration: .default)
            self.environment = environment
        }
        
        // MARK: - Methods
        
        func execute(request: Request, completion: @escaping (Data) -> Void) throws {
            let request = try self.prepare(request: request)
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    print(error.localizedDescription)
                    // 에러 처리 구문 만들기
                }
                guard let data = data else { return }
                completion(data)
                }.resume()
        }
        
        func prepare(request: Request) throws -> URLRequest {
            
            let fullUrl = "\(environment.host)/\(request.path)"
            var apiRequest = URLRequest(url: URL(string: fullUrl)!)
            
            // 파라미터 설정
            switch request.parameters {
            case .body(let params):
                if let params = params {
                    let body = try? JSONEncoder().encode(params)
                    apiRequest.httpBody = body
                } else {
                    throw NetworkErrors.badInput
                }
            case .url(let params):
                if let params = params {
                    let queryParams = params.map { pair in
                        return URLQueryItem(name: pair.key, value: pair.value)
                    }
                    guard var components = URLComponents(string: fullUrl) else {
                        throw NetworkErrors.badInput
                    }
                    components.queryItems = queryParams
                    apiRequest.url = components.url
                } else {
                    throw NetworkErrors.badInput
                }
            }
            // 헤더 값 설정
            environment.headers.forEach { apiRequest.setValue("\($0.value)", forHTTPHeaderField: $0.key) }
            request.headers?.forEach { apiRequest.setValue("\($0.value)", forHTTPHeaderField: $0.key) }
            
            apiRequest.httpMethod = request.method.rawValue
            return apiRequest
        }
    }
}

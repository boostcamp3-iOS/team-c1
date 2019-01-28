//
//  Dispatcher.swift
//  CoCo
//
//  Created by 이호찬 on 28/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

protocol Dispatcher {
    
    func execute(request: Request, completion: @escaping (Data) -> ()) throws
    func prepare(request: Request) throws -> URLRequest?
    
    init(environment: Environment)
}

class NetworkDispatcher {
    
    // MARK: - Properties
    let session: URLSession
    
    // MARK: - Private Properties
    private var environment: Environment
    
    // MARK: - Initializer
    required init(environment: Environment) {
        self.session = URLSession(configuration: .default)
        self.environment = environment
    }
    // MARK: - Methods
    func makeNetworkProvider() -> Dispatcher {
        return NetworkDispatcher(environment: environment)
    }
}

extension NetworkDispatcher: Dispatcher {
    
    // MARK: - Methods
    func execute(request: Request, completion: @escaping (Data) -> ()) throws {
        guard let request = try self.prepare(request: request) else {
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                // 에러 처리 구문 만들기
            }
            guard let data = data else { return }
            completion(data)
            }.resume()
    }
    func prepare(request: Request) throws -> URLRequest? {
        
        let fullUrl = "\(environment.host)/\(request.path)"
        guard let url = URL(string: fullUrl) else {
            return nil
        }
        var apiRequest = URLRequest(url: url)
        
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
                let queryParams = params.map { URLQueryItem(name: $0.key, value: $0.value) }
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
        environment.headerDic.forEach { apiRequest.setValue("\($0.value)", forHTTPHeaderField: $0.key) }
        request.headerDic?.forEach { apiRequest.setValue("\($0.value)", forHTTPHeaderField: $0.key) }
        apiRequest.httpMethod = request.method.rawValue
        return apiRequest
    }
}

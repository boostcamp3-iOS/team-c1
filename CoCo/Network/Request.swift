//
//  Request.swift
//  CoCo
//
//  Created by 이호찬 on 25/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

class Request {
    // MARK: - Methods

    func request<T: Decodable>(url: URLRequest, completion: @escaping (T) -> Void, errorHandler: @escaping () -> Void) {

        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, _: URLResponse?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                errorHandler()
                return
            }

            guard let data = data else {
                errorHandler()
                return
            }
            do {
                let apiResponse: T = try JSONDecoder().decode(T.self, from: data)
                completion(apiResponse)
            } catch let error {
                errorHandler()
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }

}

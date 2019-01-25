//
//  String+SearchKey.swift
//  YJCoCo
//
//  Created by 최영준 on 25/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

extension String {
    /// 검색 키워드를 분할한다
    var splitSearchKey: [String]? {
        var components = self.components(separatedBy: " ")
        let keys = components.filter { $0.contains("/") }.flatMap { $0.components(separatedBy: "/") }
        let _index = components.firstIndex { $0.contains("/") }
        guard let index = _index else {
            return nil
        }
        var results = [String]()
        for key in keys {
            components[index] = key
            results.append(components.joined(separator: " "))
        }
        return results
    }
}

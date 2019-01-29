//
//  String+SearchWords.swift
//  CoCo
//
//  Created by 최영준 on 25/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

extension String {
    /// 검색어를 생성한다
    var createSearchWords: [String] {
        // 분할할 단어가 있는지 확인한다
        guard self.contains("/") else { return [self] }
        var searchWords = [String]()
        // " "을 기준으로 문자열을 나누어 배열을 생성
        var components = self.components(separatedBy: " ")
        // 생성한 배열에서 "/"가 포함된 원소를 다시 "/"을 기준으로 나누어 배열을 생성한다
        let dividedWords = components.filter { $0.contains("/") }.flatMap { $0.components(separatedBy: "/") }
        // 대체할 원소("/"가 포함된 문자열)의 인덱스를 찾는다
        let firstIndex = components.firstIndex { $0.contains("/") }
        if let index = firstIndex {
            // 나눠진 단어들을 대체할 인덱스에 할당하여 검색어를 생성한다
            for word in dividedWords {
                components[index] = word
                searchWords.append(components.joined(separator: " "))
            }
        }
        return (searchWords.isEmpty) ? [self] : searchWords
    }
    
    /// 검색 페이지에서 사용자 검색어에 활용된다
    var isContainsPet: Bool {
        if contains(PetType.cat.rawValue) || contains(PetType.dog.rawValue) {
            return true
        }
        return false
    }
}

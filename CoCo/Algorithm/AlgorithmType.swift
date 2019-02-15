//
//  AlgorithmType.swift
//  CoCo
//
//  Created by 최영준 on 01/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

// MARK: - AlgorithmType
protocol AlgorithmType: MakeSearchWordsType, PaginationType { }

protocol MakeSearchWordsType: WordType {
    func makeRequestSearchWords(with myGoods: [MyGoodsData], words: [String], petKeyword: PetKeywordData, count: UInt?) -> [String]
    func makeRecommendedSearchWords(with words: [String], petKeyword: PetKeywordData, count: UInt?) -> [String]
    func makeSearchWords(in words: [String], count: UInt?) -> [String]
    func makeSearchWords(_ word: String) -> [String]
    func makeCleanTitle(_ title: String, isReplacing: Bool) -> String
}

protocol WordType {
    func petIncluded(in word: String) -> Bool
    func combinePet(_ pet: Pet, and words: [String]) -> [String]
    func combinePet(_ pet: Pet, and word: String) -> String
    func removePet(from words: [String]) -> [String]
    func removePet(from word: String) -> String
    func removeHTML(from string: String) -> String
    func replaceNewLine(from string: String) -> String
}

protocol PaginationType { }

// MARK: - QueueOperationType
protocol QueueOperationType {
    associatedtype T
    mutating func enqueue(_ element: T)
    mutating func dequeue() -> T?
}

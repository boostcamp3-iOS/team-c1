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
    func makeRequestSearchWords(favorite: [MyGoodsData], recent: [MyGoodsData], words: [String], count: Int) -> [String]
    func makeSearchWords(in words: [String], count: Int) -> [String]
    func makeSearchWords(_ word: String) -> [String]
}

protocol WordType {
    func petIncluded(in word: String) -> Bool
    func combinePet(_ pet: Pet, and words: [String]) -> [String]
    func combinePet(_ pet: Pet, and word: String) -> String
    func removePet(from words: [String]) -> [String]
    func removePet(from word: String) -> String
}

protocol PaginationType { }

// MARK: - QueueOperationType
protocol QueueOperationType {
    associatedtype T
    mutating func enqueue(_ element: T)
    mutating func dequeue() -> T?
}

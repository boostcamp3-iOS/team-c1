//
//  AlgorithmProtocol.swift
//  CoCo
//
//  Created by 최영준 on 29/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

// MARK: - Keyword, Category protocol
protocol Word {
    associatedtype T
    var name: String { get }
    var type: T { get }
    init(_ type: T, pet: PetType)
}

// MARK: - AlgorithmManager protocols
protocol Algorithm: class, UserInterest, Recommend {
    init(pet: PetType, keywords: [KeywordType])
}

protocol UserInterest {
    func changePet(_ type: PetType)
    func addKeyword(_ type: KeywordType)
    func removeKeyword(_ type: KeywordType) -> Keyword?
}

protocol Recommend {
    func recommendProducts(count: Int) -> [String]
    func recommendSearchWords(count: Int) -> [String]
}

// MARK: - Queue protocol
protocol QueueOperation {
    associatedtype T
    mutating func enqueue(_ element: T)
    mutating func dequeue() -> T?
}

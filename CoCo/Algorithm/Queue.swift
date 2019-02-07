//
//  Queue.swift
//  CoCo
//
//  Created by 최영준 on 27/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

private let defaultCapacity = 10

struct Queue<T: Comparable>: QueueOperationType {
    // MARK: - Properties
    /// 최신 등록 순의 데이터
    var latestData: [T] {
        return data.reversed()
    }
    var count: Int {
        return data.count
    }
    var isFull: Bool {
        return data.count == capacity
    }
    var isEmpty: Bool {
        return data.isEmpty
    }

    // MARK: - Private properties
    private var data = [T]()
    private let capacity: Int

    // MARK: - Initializer
    init(_ capacity: Int = defaultCapacity, elements: [T] = []) {
        self.capacity = capacity
        if !elements.isEmpty {
            enqueue(elements)
        }
    }

    // MARK: - Enqueue & Dequeue
    mutating func enqueue(_ element: T) {
        // 중복된 원소인 경우 제외시킨다
        data = data.filter {
            $0 != element
        }
        // 큐가 꽉 찼다면, 오래된 원소를 제거 후 새로운 원소 추가
        if isFull {
            dequeue()
        }
        data.append(element)
    }

    mutating func enqueue(_ elements: [T]) {
        for element in elements {
            enqueue(element)
        }
    }

    @discardableResult mutating func dequeue() -> T? {
        return data.removeFirst()
    }

    // MARK: - Convenience methods
    func shuffled() -> [T] {
        return data.shuffled()
    }

    mutating func clear() {
        data.removeAll()
    }
}

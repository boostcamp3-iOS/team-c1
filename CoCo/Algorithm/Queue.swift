//
//  Queue.swift
//  CoCo
//
//  Created by 최영준 on 27/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

fileprivate let queueCapacity = 10

struct Queue<T: Comparable> {
    // MARK: - Properties
    
    /// 최신 등록 순의 데이터
    var data: [T] {
        // 큐에 추가된 순서(오래된순)의 데이터를 최신순으로 뒤집는다
        return _data.reversed()
    }
    var count: Int { return _data.count }
    var isFull: Bool { return _data.count == capacity }
    var isEmpty: Bool { return _data.isEmpty }
    
    // MARK: - Private properties
    
    private var _data = [T]()
    private let capacity = queueCapacity
    
    // MARK: - Enqueue & Dequeue
    
    mutating func enqueue(_ element: T) {
        // 중복된 원소인 경우 제외시킨다
        _data = _data.filter { $0 != element }
        // 큐가 꽉 찼다면, 오래된 원소를 제거 후 새로운 원소 추가
        if isFull { dequeue() }
        _data.append(element)
    }
    
    @discardableResult mutating func dequeue() -> T? {
        return _data.removeFirst()
    }
    
    // MARK: - Convenience methods
    
    func shuffled() -> [T] {
        return _data.shuffled()
    }
    
    mutating func clear() {
        _data.removeAll()
    }
}

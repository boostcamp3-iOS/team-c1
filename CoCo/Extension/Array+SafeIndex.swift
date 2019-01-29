//
//  Array+SafeIndex.swift
//  CoCo
//
//  Created by 최영준 on 25/01/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

extension Array {
    /// 안전한 인덱스 접근
    subscript(safeIndex index: Int) -> Element? {
        if indices.contains(index) { return self[index] }
        return nil
    }
}

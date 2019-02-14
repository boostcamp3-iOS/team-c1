//
//  MyGoodsDataDelegate.swift
//  CoCo
//
//  Created by 최영준 on 14/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

protocol MyGoodsDataDelegate: class {
    func receiveData(_ data: MyGoodsData)
    func receiveSender(_ sender: Any)
}

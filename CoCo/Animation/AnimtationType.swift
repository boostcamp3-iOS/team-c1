//
//  AnimtationType.swift
//  CoCo
//
//  Created by 최영준 on 21/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

/**
 Animation Delegate
 
 - Author: [최영준](https://github.com/0jun0815)
 */
protocol AnimationType: class {
    func animation(_ animation: Animation, didSelect node: AnimationNode)
    func animation(_ animation: Animation, didDeselect node: AnimationNode)
}

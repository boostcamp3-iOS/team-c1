//
//  UIColor+.swift
//  CoCo
//
//  Created by 강준영 on 16/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

extension UIColor {
    func randomColor(index: Int) -> UIColor {
        var colorIndex = index
        let colorChips = [UIColor(red: 1.0, green: 189.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0), UIColor(red: 186.0 / 255.0, green: 166.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0), UIColor(red: 250.0 / 255.0, green: 165.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0), UIColor(red: 166.0 / 255.0, green: 183.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)]

        while colorIndex > colorChips.count - 1 {
            colorIndex -= colorChips.count
        }
        return colorChips[colorIndex]
    }

}

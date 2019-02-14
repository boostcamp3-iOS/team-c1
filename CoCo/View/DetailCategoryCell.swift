//
//  DetailCategotyCell.swift
//  CoCo
//
//  Created by 강준영 on 14/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

class DetailCategoryCell: UICollectionViewCell {
    @IBOutlet weak var detailCategoryLabel: UILabel!

    override func awakeFromNib() {
        layer.cornerRadius = 10
        layer.masksToBounds = false
    }
}

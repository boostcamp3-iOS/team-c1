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
    @IBOutlet weak var categoryBackground: UIView!

    override func awakeFromNib() {
        detailCategoryLabel.textColor = UIColor.white
        categoryBackground.layer.cornerRadius = 15
    }
}

//
//  CoCoCell.swift
//  CoCo
//
//  Created by 강준영 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

class GoodsCell: UICollectionViewCell {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var goodsTitleLabel: UILabel!
    @IBOutlet weak var goodsPriceLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var goodsShoppingMallLabel: UILabel!

    var myGoods: MyGoodsData? {
        didSet {
            if let myGoods = myGoods {
                goodsImageView.image = myGoods.image
                goodsPriceLabel.text = myGoods.price
                goodsTitleLabel.text = myGoods.title
                goodsShoppingMallLabel.text = myGoods.shoppingmall
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        container.layer.cornerRadius = 6
        container.layer.masksToBounds = true
        goodsTitleLabel.lineBreakMode = .byCharWrapping
    }
}

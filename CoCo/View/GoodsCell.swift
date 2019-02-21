//
//  CoCoCell.swift
//  CoCo
//
//  Created by 강준영 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

protocol GoodsCellDelegate: class {
    func delete(cell: GoodsCell)
}

class GoodsCell: UICollectionViewCell {
    weak var delegate: GoodsCellDelegate?

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var goodsTitleLabel: UILabel!
    @IBOutlet weak var goodsPriceLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var goodsShoppingMallLabel: UILabel!
    @IBOutlet weak var deleteButtonBackgroundView: UIVisualEffectView!
    @IBOutlet weak var deleteButton: UIButton!

    var isEditing: Bool = true {
        didSet {
            deleteButtonBackgroundView.isHidden = !isEditing
        }
    }

    var isLike: Bool = true {
        didSet {
            likeImageView.isHidden = !isLike
        }
    }

    var myGoods: MyGoodsData? {
        didSet {
            if let myGoods = myGoods {
                goodsImageView.setImage(url: myGoods.image)
                goodsPriceLabel.text = myGoods.price
                goodsTitleLabel.text = myGoods.title
                goodsShoppingMallLabel.text = myGoods.shoppingmall
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        settupGoodsCell()
        setupDelete()
    }

    override func prepareForReuse() {
        goodsImageView.image = UIImage(named: "placeholder")
    }

    func settupGoodsCell() {
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.backgroundColor = UIColor.clear.cgColor
        container.layer.cornerRadius = 6
        container.layer.masksToBounds = true
        goodsTitleLabel.sizeToFit()

        likeImageView.image = likeImageView.image!.withRenderingMode(.alwaysTemplate)
        likeImageView.tintColor = AppColor.purple
    }

    func setupDelete() {
        deleteButtonBackgroundView.layer.cornerRadius = deleteButtonBackgroundView.bounds.width / 2.0
        deleteButtonBackgroundView.layer.masksToBounds = true
        deleteButtonBackgroundView.isHidden = !isEditing
    }
}

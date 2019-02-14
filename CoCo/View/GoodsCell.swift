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

    var isEditing: Bool = true {
        didSet {
            deleteButtonBackgroundView.isHidden = !isEditing
        }
    }

    var myGoods: MyGoodsData? {
        didSet {
            if let myGoods = myGoods {
                goodsImageView.setImage(url: myGoods.image)
                goodsPriceLabel.text = myGoods.price
                goodsTitleLabel.text = myGoods.title
                print(myGoods.title.count)
                goodsShoppingMallLabel.text = myGoods.shoppingmall
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 6
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.backgroundColor = UIColor.clear.cgColor

        container.layer.cornerRadius = 6
        container.layer.masksToBounds = true
        goodsTitleLabel.lineBreakMode = .byCharWrapping

        deleteButtonBackgroundView.layer.cornerRadius = deleteButtonBackgroundView.bounds.width / 2.0
        deleteButtonBackgroundView.layer.masksToBounds = true
        deleteButtonBackgroundView.isHidden = !isEditing

    }

    @IBAction func deleteCell(_ sender: UIButton) {
        guard let delegate = delegate else {
            return
        }
        delegate.delete(cell: self)
    }
}

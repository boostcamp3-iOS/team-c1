//
//  DiscoverCollectionViewController.swift
//  CoCo
//
//  Created by 강준영 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

private let goodsIdentifier = "GoodsCell"
private let categoryIdentifier = "CategoryCell"

class DiscoverCollectionViewController: UICollectionViewController {

    var myGoods = MyGoodsDummy().dummyArray

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let collectionView = collectionView else {
            return
        }
        collectionView.register(UINib(nibName: "GoodsCell", bundle: nil), forCellWithReuseIdentifier: goodsIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 16, bottom: 10, right: 10)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)

        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        } else {
            print("else")
        }
    }
}

extension DiscoverCollectionViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myGoods.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: goodsIdentifier, for: indexPath) as? GoodsCell else {
        return UICollectionViewCell()
        }
        cell.myGoods = myGoods[indexPath.item]
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)

    }
}

extension DiscoverCollectionViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let image = myGoods[indexPath.item].image else {
            return 0
        }
        return image.size.height
    }
}

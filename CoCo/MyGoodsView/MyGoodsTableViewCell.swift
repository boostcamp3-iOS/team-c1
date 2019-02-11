//
//  MyGoodsTableViewCell.swift
//  CoCo
//
//  Created by 최영준 on 11/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

class MyGoodsTableViewCell: UITableViewCell {
    // MARK: - Private properties
    private var data = [MyGoodsData]()

    // MARK: - IBOutlets
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLable.text = nil
    }

    func updateContents(_ data: [MyGoodsData]) {
        self.data = data
        if data.isEmpty {
            collectionView.isHidden = true
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.collectionView.reloadData()
        }
    }
}

extension MyGoodsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.goodsCell, for: indexPath) as? GoodsCell else {
                return UICollectionViewCell()
        }
        // TODO: collection view cell 구현 시 변경
        if let goods = data[safeIndex: indexPath.row] {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                cell.myGoods = goods
                cell.deleteButton.isHidden = !self.isEditing
            }
        }
        return cell
    }
}

// MARK: - Private structures
extension MyGoodsTableViewCell {
    // TODO: collection view cell 구현 시 변경
    private struct CollectionViewCellIdentifier {
        static let goodsCell = "GoodsCell"
    }
}

// TODO: collection view cell 구현 시 변경
class GoodsCell: UICollectionViewCell {
    var deleteButton = UIButton()
    var myGoods: MyGoodsData?
}

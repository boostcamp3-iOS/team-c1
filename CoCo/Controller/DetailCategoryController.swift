//
//  DetailCategoryController.swift
//  CoCo
//
//  Created by 강준영 on 14/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

protocol DetailCategoryControllerDelegate: class {
    func showGoods(indexPath: IndexPath, pet: Pet, detailCategory: String)
}

class DetailCategoryController: UIView {

    // MARK: - Properties
    private let detailCellId = "DetailCategoryCell"
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    lazy var detailCategoryTitle: [String] = {
        return setupCategoryTitle()
    }()
    weak var detailCategoryDelegate: DetailCategoryControllerDelegate?
    var pet: Pet?
    var category: Category?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCategoryTitle() -> [String] {
        var categorys = [String]()
        guard let pet = pet, let category =  category else {
            return []
        }
        if pet.rawValue == "강아지" {
            categorys = category.getData(pet: Pet.dog)
        } else {
            categorys = category.getData(pet: Pet.cat)
        }
        return categorys
    }

    func setUpCollectionView() {
        self.addSubview(collectionView)
        collectionView.register(UINib(nibName: "DetailCategoryCell", bundle: nil), forCellWithReuseIdentifier: detailCellId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 1),
            collectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 5),
            collectionView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
}

extension DetailCategoryController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailCategoryTitle.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as? DetailCategoryCell else {
            return UICollectionViewCell()
        }
        cell.detailCategoryLabel.text = detailCategoryTitle[indexPath.item]
        cell.categoryBackground.backgroundColor = UIColor().randomColor(index: indexPath.row)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        let category = detailCategoryTitle[indexPath.item]
        let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        let estimateFrame = NSString(string: category).boundingRect(with: CGSize(width: itemSize, height: 1000), options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        return CGSize(width: estimateFrame.width + 40, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DetailCategoryCell {
            cell.detailCategoryLabel.font = UIFont.boldSystemFont(ofSize: 18)
        }
        guard let pet = pet else {
            return
        }
        detailCategoryDelegate?.showGoods(indexPath: indexPath, pet: pet, detailCategory: detailCategoryTitle[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DetailCategoryCell {
            cell.detailCategoryLabel.font = UIFont.systemFont(ofSize: 17)
        }
    }
}

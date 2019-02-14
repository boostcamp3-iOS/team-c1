//
//  DetailCategoryController.swift
//  CoCo
//
//  Created by 강준영 on 14/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

class DetailCategoryController: UICollectionReusableView {

    private let cellId = "DetailCategoryCell"
    var pet: Pet?
    var category: Category?

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    lazy var detailCategoryTitle: [String] = {
        return setupCategoryTitle()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDetailCategory()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCategoryTitle() -> [String] {
        var categorys = [String]()
        if pet!.rawValue == "강아지" {
            categorys.append(Pet.dog.rawValue)
        } else {
            categorys.append(Pet.cat.rawValue)
        }
        for category in Category.allCases {
            categorys.append(category.rawValue)
        }
        return categorys
    }
    func setupDetailCategory() {

    }

    func setUpCollectionView() {
        addSubview(collectionView)
        collectionView.register(UINib(nibName: "DetailCategoryCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|-10-[v0]|", views: collectionView)
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .bottom)
    }

}

extension DetailCategoryController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

}

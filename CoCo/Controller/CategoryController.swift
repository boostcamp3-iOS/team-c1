//
//  CategoryController.swift
//  CoCo
//
//  Created by 강준영 on 11/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

class CategoryController: UICollectionReusableView {

    private let cellId = "CategoryCell"
    var pet = Pet.dog

    lazy var largeTitle: LargeTitle = {
        guard let largeTitle = Bundle.main.loadNibNamed("LargeTitle", owner: self, options: nil)?.first as? LargeTitle else {
            return LargeTitle()
        }
        largeTitle.translatesAutoresizingMaskIntoConstraints = false
        largeTitle.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return largeTitle
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    lazy var categoryImage: [UIImage?] = {
       return setupCategotyImage()
    }()

    lazy var categoryTitle: [String] = {
        return setupCategoryTitle()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLargeTitle()
        setUpCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCategoryTitle() -> [String] {
        var categorys = [String]()
        if pet.rawValue == "강아지" {
            categorys.append(Pet.dog.rawValue)
        } else {
            categorys.append(Pet.cat.rawValue)
        }
        for category in Category.allCases {
            categorys.append(category.rawValue)
        }
        return categorys
    }

    func setupCategotyImage() -> [UIImage?] {
        var categoryImages = [UIImage?]()
        if pet.rawValue == "강아지" {
            categoryImages.append(UIImage(named: "dog"))
        } else {
            categoryImages.append(UIImage(named: "cat"))
        }
        categoryImages.append(UIImage(named: "pet-food"))
        categoryImages.append(UIImage(named: "treats"))
        categoryImages.append(UIImage(named: "poop"))
        categoryImages.append(UIImage(named: "vaccine"))
        categoryImages.append(UIImage(named: "grooming"))
        categoryImages.append(UIImage(named: "tennis-ball"))
        categoryImages.append(UIImage(named: "pet-house"))
        categoryImages.append(UIImage(named: "finding"))
        categoryImages.append(UIImage(named: "transporter"))
        categoryImages.append(UIImage(named: "bowl"))
        return categoryImages
    }

    func setupLargeTitle() {
        self.addSubview(largeTitle)
        self.addConstraintsWithFormat("H:|[v0]|", views: largeTitle)
        self.addConstraintsWithFormat("V:|[v0(130)]", views: largeTitle)
    }

    func setUpCollectionView() {
        addSubview(collectionView)
        collectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|-130-[v0]|", views: collectionView)
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .bottom)
    }
    
    

}

extension CategoryController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryImage.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CategotyCell else {
            return UICollectionViewCell()
        }
        cell.categoryImageView.image = categoryImage[indexPath.item]
        cell.categoryLabel.text = categoryTitle[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 5, height: 110)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click \(indexPath)")
        if indexPath.item == 0 {
            if categoryImage[0] == UIImage(named: "dog") && categoryTitle[0] == Pet.dog.rawValue {
                categoryImage[0] = UIImage(named: "cat")
                categoryTitle[0] = Pet.cat.rawValue
            } else {
                categoryImage[0] = UIImage(named: "dog")
                 categoryTitle[0] = Pet.dog.rawValue
            }
            collectionView.reloadData()
        } else {
            let discoverDetailViewController = DiscoverDetailViewController()
            discoverDetailViewController.category = Category(rawValue: categoryTitle[indexPath.item])
        }
    }
}

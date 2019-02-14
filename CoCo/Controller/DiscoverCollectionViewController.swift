//
//  DiscoverCollectionViewController.swift
//  CoCo
//
//  Created by 강준영 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
import CoreData

private let goodsIdentifier = "GoodsCell"

class DiscoverCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    weak var appDelegate: AppDelegate? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate
    }
    var context: NSManagedObjectContext? {
        return appDelegate?.persistentContainer.viewContext
    }

    var myGoods = MyGoodsDummy().dummyArray
    let networkManager = ShoppingNetworkManager.shared
    let algorithmManager = Algorithm()
    var myGoodsCoreDataManager: MyGoodsCoreDataManager?
    var searchWordCoreDataManager: SearchWordCoreDataManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let context = context else {
            return
        }
        guard let appDelegate = appDelegate else {
            return
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = PinterestLayout()

        searchWordCoreDataManager = SearchWordCoreDataManager()
        myGoodsCoreDataManager = MyGoodsCoreDataManager()

        let discoverService = DiscoverServiceClass(networkManagerType: networkManager, algorithmManagerType: algorithmManager, searchWordDoreDataManagerType: searchWordCoreDataManager, myGoodsCoreDataType: myGoodsCoreDataManager)

        collectionView.register(UINib(nibName: "GoodsCell", bundle: nil), forCellWithReuseIdentifier: goodsIdentifier)
        collectionView.register(CategoryController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "categoryView")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        } else {
            print("else")
        }

    }

    func coreDataPrint() {
        let coredataManager = MyGoodsCoreDataManager()

        let pet = Pet.cat
        var myGoods1 = MyGoodsData()
        myGoods1.title = "고양이 방석 국내산 제작, 폭신폭신 아기들이 좋아해요"
        myGoods1.image = ""
        myGoods1.isFavorite = false
        myGoods1.isLatest = true
        myGoods1.link = ""
        myGoods1.pet = pet
        myGoods1.price = "1500"
        myGoods1.productID = "113333444778"
        myGoods1.shoppingmall = "마루"

        try? coredataManager.insert(myGoods1)
        print(myGoods1)

        myGoods1.date = myGoods1.createDate()
        myGoods1.isLatest = false
        try? coredataManager.updateObject(myGoods1)
        print(myGoods1)
        let core = coredataManager.fetchProductID(productID: "1133334444r")
        core?.isFavorite = true
        try? coredataManager.updateObject(core)

        let data = try? coredataManager.fetchFavoriteGoods(pet: pet)
        print("favorite: \(data)")

        print(try? coredataManager.fetchObjects(pet: pet))

        let data1 = try? coredataManager.fetchLatestGoods(pet: pet, isLatest: false, ascending: true)
        print("Latest: \(data1)")
    }
}

extension DiscoverCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myGoods.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

   func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let haeder = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "categoryView", for: indexPath) as? CategoryController else {
            return UICollectionReusableView()
        }
        return haeder
    }
}

extension DiscoverCollectionViewController: PinterestLayoutDelegate {
    func headerFlexibleHeight(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        return 230
    }

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
         let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        let title = myGoods[indexPath.item].title
        let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        let estimateFrame = NSString(string: title).boundingRect(with: CGSize(width: itemSize, height: 1000), options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        return estimateFrame.height + 250
    }

}

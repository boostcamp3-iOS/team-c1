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
    let pet = " 고양이"
    var shopItems = [MyGoodsData]()
    var discoverService: DiscoverServiceClass?
    let networkManager = ShoppingNetworkManager.shared
    let algorithmManager = Algorithm()
    var myGoodsCoreDataManager: MyGoodsCoreDataManager?
    var searchWordCoreDataManager: SearchWordCoreDataManager?
    var petKeywordCoreDataManager: PetKeywordCoreDataManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollctionView()
        setupHeader()
        loadData()
    }

    func setupHeader() {
        collectionView.register(CategoryController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "categoryView")
    }

    func setupCollctionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = PinterestLayout()
        collectionView.register(UINib(nibName: "GoodsCell", bundle: nil), forCellWithReuseIdentifier: goodsIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        } else {
            print("else")
        }
    }

    func loadData() {
        petKeywordCoreDataManager = PetKeywordCoreDataManager()
        searchWordCoreDataManager = SearchWordCoreDataManager()
        myGoodsCoreDataManager = MyGoodsCoreDataManager()

        discoverService = DiscoverServiceClass(networkManagerType: networkManager, algorithmManagerType: algorithmManager, searchWordDoreDataManagerType: searchWordCoreDataManager, myGoodsCoreDataType: myGoodsCoreDataManager, petKeywordCoreDataManagerType: petKeywordCoreDataManager)

        guard let discoverService = discoverService else {
            return
        }

        discoverService.fetchPetKeywords()
        discoverService.fetchSearchWord()
        discoverService.fetchMyGoods()
        discoverService.mixedWord()
        discoverService.request { (isSuccess, _) in
            if isSuccess {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.shopItems = discoverService.fetchedMyGoods
                    self.collectionView.reloadData()
                }
            }
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        <#code#>
    }
}

extension DiscoverCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: goodsIdentifier, for: indexPath) as? GoodsCell else {
            return UICollectionViewCell()
        }
        cell.myGoods = shopItems[indexPath.item]
        cell.isEditing = false
        return cell
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let myGoodsData = shopItems[indexPath.item]
        self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        
    }
}

extension DiscoverCollectionViewController: PinterestLayoutDelegate {
    func headerFlexibleHeight(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        return 230
    }

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        let title = shopItems[indexPath.item].title
        print(title)
        let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        let estimateFrame = NSString(string: title).boundingRect(with: CGSize(width: itemSize, height: 1000), options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        return estimateFrame.height + 250
    }
}

//
//  DiscoverCollectionViewController.swift
//  CoCo
//
//  Created by 강준영 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
import CoreData

class DiscoverViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private let goodsIdentifier = "GoodsCell"

    let toWebSegue = "discoverToWeb"
    var discoverService: DiscoverService?
    let networkManager = ShoppingNetworkManager.shared
    let algorithmManager = Algorithm()
    var myGoodsCoreDataManager = MyGoodsCoreDataManager()
    var searchWordCoreDataManager = SearchWordCoreDataManager()
    var petKeywordCoreDataManager = PetKeywordCoreDataManager()
    var isInserting = false
    var layout: PinterestLayout?
    var pagenationNum = 1

    // 둘러보기
    override func viewDidLoad() {
        super.viewDidLoad()
        UIViewController.presentPetKeywordViewController()
        petkeyWordCoreDataPrint()
        setupCollctionView()
        setupHeader()
        layout = collectionView.collectionViewLayout as? PinterestLayout
        layout?.delegate = self
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = false
    }

    func setupHeader() {
        collectionView.register(CategoryController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "categoryView")
    }

    func setupCollctionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = PinterestLayout()
        collectionView.register(UINib(nibName: "GoodsCell", bundle: nil), forCellWithReuseIdentifier: goodsIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func loadData() {
        discoverService = DiscoverService(networkManagerType: networkManager, algorithmManagerType: algorithmManager, searchWordDoreDataManagerType: searchWordCoreDataManager, myGoodsCoreDataManagerType: myGoodsCoreDataManager, petKeywordCoreDataManagerType: petKeywordCoreDataManager)

        guard let discoverService = discoverService else {
            return
        }
        discoverService.fetchPet()
        discoverService.fetchPetKeywords()
        discoverService.fetchSearchWord()
        discoverService.fetchMyGoods()
        discoverService.mixedWord()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let webViewController: WebViewController  = segue.destination as? WebViewController else {
            return
        }
        guard let indexPath = sender as? IndexPath else {
            return
        }
        guard let discoverService = discoverService else {
            return
        }
        webViewController.sendData(discoverService.fetchedMyGoods[indexPath.item])
    }
}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard  let discoverService = discoverService else {
            return 0
        }
        print("DC: \(discoverService.fetchedMyGoods.count)")
        return discoverService.fetchedMyGoods.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: goodsIdentifier, for: indexPath) as? GoodsCell else {
            return UICollectionViewCell()
        }
        cell.myGoods = discoverService?.fetchedMyGoods[indexPath.row]
        cell.isEditing = false
        cell.isLike = false
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "categoryView", for: indexPath) as? CategoryController else {
            return UICollectionReusableView()
        }
        header.categoryDelegate = self
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let myGoodsData = discoverService?.fetchedMyGoods[indexPath.item]
        self.performSegue(withIdentifier: toWebSegue, sender: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) - 50)
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) - 50) {
            if !isInserting {
                isInserting = true
                discoverService?.request(completion: { [weak self]
                    (isSuccess, _) in
                    guard let self = self else {
                        return
                    }
                    if isSuccess {
                        DispatchQueue.main.async {
                            self.layout?.setCellPinterestLayout(indexPathRow: self.pagenationNum - 1) {}
                            self.collectionView.reloadData()
                            self.pagenationNum += 20
                        }
                        self.isInserting = false
                    }
                })
            }
        }
    }
}

extension DiscoverViewController: PinterestLayoutDelegate {
    func headerFlexibleHeight(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        return 230
    }

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let discoverService = discoverService else {
            return 0
        }
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        let title = discoverService.fetchedMyGoods[indexPath.item].title
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        let estimateFrame = NSString(string: title).boundingRect(with: CGSize(width: itemSize, height: 1000), options: option, attributes: attribute, context: nil)
        print("itemggg \(indexPath) of \(estimateFrame.height)")
        return estimateFrame.height + 250
    }
}

extension DiscoverViewController: CategoryControllerDelegate {
    func goDiscoverDetail(indexPath: IndexPath, pet: Pet, category: Category) {
        let discoverDetailViewController = DiscoverDetailViewController()
        let discoverDetailCategory = DetailCategoryController()
        discoverDetailCategory.pet = pet
        discoverDetailCategory.category = category
        discoverDetailViewController.category = category
        discoverDetailViewController.pet = pet
        navigationController?.pushViewController(discoverDetailViewController, animated: true)
    }
}

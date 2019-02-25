//
//  DiscoverCollectionViewController.swift
//  CoCo
//
//  Created by 강준영 on 09/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit
import CoreData

protocol DiscoverViewControllerDelegate: class {
    func petChanged(pet: Pet)
}

class DiscoverViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private let goodsIdentifier = "GoodsCell"
    private let toWebSegue = "discoverToWeb"
    private let networkManager = ShoppingNetworkManager.shared
    private let algorithmManager = Algorithm()
    private let settingPetKeyword = SettingViewController()
    private let searchWordCoreDataManager = SearchWordCoreDataManager()
    private var discoverService: DiscoverService?
    private var myGoodsCoreDataManager = MyGoodsCoreDataManager()
    private var petKeywordCoreDataManager = PetKeywordCoreDataManager()
    private var isInserting = false
    private var layout: PinterestLayout?
    private var activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    fileprivate var pagenationNum = 1
    fileprivate var headerSize: CGFloat = 230
    fileprivate var pet = PetDefault.shared.pet
    weak var delegate: DiscoverViewControllerDelegate?

    // 둘러보기
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollctionView()
        setupHeader()
        setupIndicator()
        layout = collectionView.collectionViewLayout as? PinterestLayout
        layout?.delegate = self
        loadData()
        pet = PetDefault.shared.pet
        extendedLayoutIncludesOpaqueBars = true
        print("pet: \(pet)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = false
        if pet != PetDefault.shared.pet {
            print("PetDefault: \(PetDefault.shared.pet)")
            pagenationNum = 1
            self.layout?.setupInit()
            self.layout?.invalidateLayout()
            discoverService?.fetchedMyGoods.removeAll()
            loadData()
            pet = PetDefault.shared.pet
            delegate?.petChanged(pet: pet)
            collectionView.reloadData()
        }

    }

    func setupIndicator() {
        activityIndicatorView.color = UIColor.gray
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.frame = self.view.frame
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
    }

    func setupHeader() {
        collectionView.register(CategoryController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "categoryView")
    }

    func setupCollctionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = PinterestLayout()
        collectionView.register(UINib(nibName: "GoodsCell", bundle: nil), forCellWithReuseIdentifier: goodsIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        if !isInserting {
            isInserting = true
            discoverService.request(completion: { [weak self]
                (isSuccess, error, _) in
                guard let self = self else {
                    return
                }
                if error != nil {
                    self.alert("데이터를 가져오지 못했습니다.")
                }
                if isSuccess {
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        self.layout?.setCellPinterestLayout(indexPathRow: self.pagenationNum - 1) {
                            self.collectionView.reloadData()
                            self.pagenationNum += 20
                        }
                    }
                    self.isInserting = false
                }
            })
        }
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
        self.delegate = header
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: toWebSegue, sender: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y

        if scrollPosition > 0, scrollPosition < scrollView.contentSize.height * 0.1 {
            pagination()
        }

    }

    func pagination() {
        if !isInserting {
            isInserting = true
            discoverService?.request(completion: { [weak self]
                (isSuccess, error, newData) in
                guard let self = self else {
                    return
                }
                if error != nil {
                    self.alert("데이터를 가져오지 못했습니다.")
                }
                guard let newData = newData else {
                    return
                }
                if isSuccess {
                    DispatchQueue.main.async {
                        self.layout?.setCellPinterestLayout(indexPathRow: self.pagenationNum - 1) {
                            self.collectionView.insertItems(at:
                                self.getIndexPath(newData: newData))
                            self.pagenationNum += 20
                        }
                    }
                    self.isInserting = false
                }
            })
        }
    }

    func getIndexPath(newData: Int) -> [IndexPath] {
        guard let discoverService = discoverService else {
            return []
        }
        var arrList = [IndexPath]()
        let startCount = discoverService.fetchedMyGoods.count - newData
        let endCount = startCount + newData
        (startCount..<endCount).forEach {
            arrList.append(IndexPath(item: $0, section: 0))
        }
        return arrList
    }
}

extension DiscoverViewController: PinterestLayoutDelegate {
    func headerFlexibleHeight(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        return headerSize
    }

    func collectionView(_ collectionView: UICollectionView, heightForTitleIndexPath indexPath: IndexPath) -> CGFloat {
        guard let discoverService = discoverService else {
            return 0
        }
        let itemSize = (collectionView.frame.width / 2) - 40
        let title = discoverService.fetchedMyGoods[indexPath.item].title
        let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimateFrame = NSString(string: title).boundingRect(with: CGSize(width: itemSize, height: 1000), options: option, attributes: attribute, context: nil)
        return estimateFrame.height + view.frame.width*2/3
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

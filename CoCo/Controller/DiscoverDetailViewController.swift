//
//  DiscoverDetailViewController.swift
//  CoCo
//
//  Created by 강준영 on 14/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

class DiscoverDetailViewController: UIViewController {

    private let goodsIdentifier = "GoodsCell"
    let searchWorCoreDataManager = SearchWordCoreDataManager()
    let petKeywordCoreDataManager = PetKeywordCoreDataManager()
    let networkManager = ShoppingNetworkManager.shared
    let algorithmManager = Algorithm()
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: PinterestLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    var discoverDetailService: DiscoverDetailService?
    var goodsList = [MyGoodsData]()
    var searchWord = ""
    var category: Category?
    var pet: Pet?
    var layout: PinterestLayout?
    var isInserting = false
    var pagenationNum = 1

    // 카테고리디테일
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = "CoCo"
        navigationItem.largeTitleDisplayMode = .never
        setupHeader()
        setupCollctionView()
        layout = collectionView.collectionViewLayout as? PinterestLayout
        layout?.delegate = self
        loadData()
        print("viewdid")

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("reload")

    }

    func setupCollctionView() {
        view.addSubview(collectionView)
        let goodsCellView = UINib(nibName: "GoodsCell", bundle: nil)
        collectionView.register(goodsCellView, forCellWithReuseIdentifier: goodsIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = PinterestLayout()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

    func setupHeader() {
        collectionView.register(DetailCategoryController.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "detailCategoryView")
    }

    func loadData() {
        discoverDetailService = DiscoverDetailService(serachCoreData: searchWorCoreDataManager, petCoreData: petKeywordCoreDataManager, network: networkManager, algorithm: algorithmManager)
        guard let pet = pet else {
            return
        }
        discoverDetailService?.setPet(pet: pet)
        guard let search = category?.getData(pet: pet).first else {
            return
        }
        searchWord = search
    }
}

extension DiscoverDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataCount = discoverDetailService?.dataLists.count else {
            return 0
        }
        return dataCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: goodsIdentifier, for: indexPath) as? GoodsCell else {
            return UICollectionViewCell()
        }
        cell.myGoods = discoverDetailService?.dataLists[indexPath.item]
        cell.isEditing = false
        cell.isLike = false
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "detailCategoryView", for: indexPath) as? DetailCategoryController else {
            return UICollectionReusableView()
        }
        header.detailCategoryDelegate = self
        header.category = category
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let discoverDetailService = discoverDetailService else {
            return
        }
        let webViewStoryboard = UIStoryboard(name: "WebView", bundle: nil)
        guard let webViewController: WebViewController  = webViewStoryboard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else {
            return
        }
        webViewController.sendData(discoverDetailService.dataLists[indexPath.item])
        print(indexPath)
        navigationController?.pushViewController(webViewController, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) - 50)
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) - 50) {
            if !isInserting {
                isInserting = true
                discoverDetailService?.getShoppingData(start: pagenationNum, search: searchWord, completion: { [weak self]
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

extension DiscoverDetailViewController: PinterestLayoutDelegate {
    // MARK: - Delegate Methodes
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        let title = discoverDetailService?.dataLists[indexPath.item].title ?? ""
        let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimateFrame = NSString(string: title).boundingRect(with: CGSize(width: itemSize, height: 1000), options: option, attributes: attribute, context: nil)
        return estimateFrame.height + 250
    }

    func headerFlexibleHeight(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        return 90
    }

    func sortChanged(sort: SortOption) {
        discoverDetailService?.sortOption = sort
        discoverDetailService?.getShoppingData(start: 1, search: searchWord ?? "") { isSuccess, err in
            if isSuccess {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                if err == NetworkErrors.noData {
                    self.alert("데이터가 없습니다. 다른 검색어를 입력해보세요")
                } else {
                    self.alert("네트워크 연결이 끊어졌습니다.")
                }
            }
        }
    }
}

extension DiscoverDetailViewController: DetailCategoryControllerDelegate {
    func sortGoods() {
        let actionSheet = UIAlertController(title: nil, message: "정렬 방식을 선택해주세요", preferredStyle: .actionSheet)

        let sortSim = UIAlertAction(title: "유사도순", style: .default) { _ in
            self.sortChanged(sort: .similar)
        }
        let sortAscending = UIAlertAction(title: "가격 오름차순", style: .default) { _ in
            self.sortChanged(sort: .ascending)
        }
        let sortDescending = UIAlertAction(title: "가격 내림차순", style: .default) { _ in
            self.sortChanged(sort: .descending)
        }
        let sortDate = UIAlertAction(title: "날짜순", style: .default) { _ in
            self.sortChanged(sort: .date)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionSheet.addAction(sortSim)
        actionSheet.addAction(sortAscending)
        actionSheet.addAction(sortDescending)
        actionSheet.addAction(sortDate)
        actionSheet.addAction(cancel)

        present(actionSheet, animated: true, completion: nil)
    }

    func showGoods(indexPath: IndexPath, pet: Pet, detailCategory: String) {
        print(detailCategory)
        searchWord = detailCategory
        pagenationNum = 1
        discoverDetailService?.dataLists.removeAll()
        print("remove listCount - \(discoverDetailService?.dataLists.count)")
        discoverDetailService?.getShoppingData(start: 1, search: detailCategory) { [weak self] (isSuccess, _) in
            if isSuccess {
                DispatchQueue.main.async { [weak self] in
                    self?.layout?.setupInit()
                    self?.layout?.invalidateLayout()
                    self?.collectionView.reloadData()
                }
            }

        }
    }
}

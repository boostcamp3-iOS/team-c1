//
//  SearchViewController.swift
//  CoCo
//
//  Created by 이호찬 on 11/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: class {
    func tapKeywordCell(keyword: String)
}

class SearchViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    enum CellIdentifier: String {
        case searchKeyword = "SearchKeywordCell"
        case goods = "GoodsCell"
    }

    // MARK: - Private Properties
    private var cellIdentifier = CellIdentifier.searchKeyword

    // MARK: - Properties
    weak var delegate: SearchViewControllerDelegate?
    var pinterestLayout = PinterestLayout()
    var centerAlignLayout = CenterAlignedCollectionViewFlowLayout()
    var isInserting = false

    let searchService = SearchService(serachCoreData: SearchWordCoreDataManager(),
                                      petCoreData: PetKeywordCoreDataManager(),
                                      network: ShoppingNetworkManager.shared,
                                      algorithm: Algorithm())

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        self.activityIndicator.stopAnimating()
        searchService.fetchRecommandSearchWord {
            self.collectionView.reloadData()
        }
        //        petkeyWordCoreDataPrint()
        collectionView.collectionViewLayout = centerAlignLayout

        collectionView.register(UINib(nibName: "GoodsCell", bundle: nil), forCellWithReuseIdentifier: CellIdentifier.goods.rawValue)

        // Do any additional setup after loading the view.
    }
//    func petkeyWordCoreDataPrint() {
//        let petKeywordDataManager = PetKeywordCoreDataManager()
//        let dummy = PetKeywordDummy().petkeys
//
//        do {
//            for data in dummy {
//                let insert = try petKeywordDataManager.insert(data)
//            }
//            let fetch = try petKeywordDataManager.fetchObjects()
//            print(fetch)
//        } catch let error {
//            print(error)
//        }
//    }
//
//    struct PetKeywordDummy {
//        let cat = "고양이"
//        let dog = "강아지"
//        var petkeys = [PetKeywordData]()
//
//        init() {
//            let catKeyword = PetKeywordData(pet: self.cat, keywords: ["놀이", "배변", "스타일", "리빙"])
//            let dogKeyword = PetKeywordData(pet: self.dog, keywords: ["헬스", "외출", "배변", "리빙"])
//
//            petkeys.append(catKeyword)
//            petkeys.append(dogKeyword)
//        }
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    // MARK: - IBActions
    @IBAction func actionTappedScreen(_ sender: UITapGestureRecognizer) {
        // delegate 가 탭 제스쳐와 겹쳐서 DidSelectItemAt 대신 사용
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            switch cellIdentifier {
            case .searchKeyword:
                guard let cell = self.collectionView?.cellForItem(at: indexPath) as? SearchKeywordCollectionViewCell else {
                    return
                }
                let search = cell.titleLabel.text ?? ""
                self.activityIndicator.startAnimating()
                delegate?.tapKeywordCell(keyword: search)
                searchService.sortOption = .similar
                searchService.insert(recentSearchWord: search)
                searchService.getShoppingData(search: search) { isSuccess, err in
                    if isSuccess {
                        self.reload(.goods)
                    } else {
                        if err == NetworkErrors.noData {
                            self.alert("데이터가 없습니다. 다른 검색어를 입력해보세요")
                        } else {
                            self.alert("네트워크 연결이 끊어졌습니다.")
                        }
                    }
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                }
            case .goods:
                performSegue(withIdentifier: "searchToWeb", sender: indexPath)
            }
        } else {
            view.endEditing(true)
        }
    }

    // MARK: - Methods
    func reload(_ cell: CellIdentifier) {
        DispatchQueue.main.async {
            self.cellIdentifier = cell
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
            if cell == .goods {
                self.pinterestLayout = PinterestLayout()
                self.pinterestLayout.delegate = self
                self.collectionView.setCollectionViewLayout(self.pinterestLayout, animated: false)
                self.collectionView.collectionViewLayout.invalidateLayout()
            } else {
                self.centerAlignLayout = CenterAlignedCollectionViewFlowLayout()
                self.collectionView.setCollectionViewLayout(self.centerAlignLayout, animated: false)
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let webViewController: WebViewController = segue.destination as? WebViewController else {
            return
        }
        guard let indexPath: IndexPath = sender as? IndexPath else {
            return
        }
        webViewController.sendData(searchService.dataLists[indexPath.row])
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch cellIdentifier {
        case .searchKeyword:
            return searchService.keyword.count
        case .goods:
            return searchService.dataLists.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier.rawValue, for: indexPath)
        switch cellIdentifier {
        case .searchKeyword:
            guard let cell = collectionViewCell as? SearchKeywordCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.titleLabel.text = searchService.keyword[indexPath.row]

            var iii = indexPath.row
            while iii > searchService.colorChips.count - 1 {
                iii -= searchService.colorChips.count
            }

            cell.colorBackgroundView.backgroundColor = searchService.colorChips[iii]
            return cell
        case .goods:
            guard let cell = collectionViewCell as? GoodsCell else {
                return UICollectionViewCell()
            }
            cell.myGoods = searchService.dataLists[indexPath.row]
            cell.isLike = false
            cell.isEditing = false
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchCollectionReusableView", for: indexPath) as? SearchCollectionReusableView else {
            return UICollectionReusableView()
        }
        switch cellIdentifier {
        case .searchKeyword:
            header.sortButton.isHidden = true
        case .goods:
            header.sortButton.isHidden = false
        }

        header.delegate = self
        self.delegate = header

        return header
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }

    // SrcollDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        let scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y
        if scrollPosition > 0 && scrollPosition < scrollView.contentSize.height * 0.1 {

            if !isInserting {
                isInserting = true
                self.searchService.itemStart += 20
                searchService.getShoppingData(search: searchService.recentSearched ?? "") { [weak self] isSuccess, err in
                    guard let self = self else {
                        return
                    }
                    if isSuccess {
                        DispatchQueue.main.async {
                            self.pinterestLayout.setCellPinterestLayout(indexPathRow: self.searchService.itemStart - 21) {
                                print(self.searchService.dataLists.count)
                                self.collectionView.reloadData()
                                self.isInserting = false
                                print(self.isInserting)
                            }
                        }
                    } else {
                        print(err)
                    }
                }
            }
        }
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cellIdentifier {
        case .searchKeyword:
            let text = searchService.keyword[indexPath.row] as NSString
            let length = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]).width + 32

            return CGSize(width: length, height: 32)
        case .goods:
            let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
            return CGSize(width: itemSize, height: itemSize)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch cellIdentifier {
        case .searchKeyword:
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        case .goods:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }

    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let url = searchService.dataLists[indexPath.row].image
            ImageManager.shared.cacheImage(url: url, isDisk: false) {_ in}
        }
    }
}

extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension SearchViewController: SearchCollectionReusableViewDelegate {
    func searchButtonClicked(_ search: String) {
        view.endEditing(true)
        self.activityIndicator.startAnimating()
        searchService.sortOption = .similar
        searchService.insert(recentSearchWord: search)
        searchService.itemStart = 1
        searchService.getShoppingData(search: search) { isSuccess, err in
            if isSuccess {
                self.reload(.goods)
            } else {
                if err == NetworkErrors.noData {
                    self.alert("데이터가 없습니다. 다른 검색어를 입력해보세요")
                } else {
                    self.alert("네트워크 연결이 끊어졌습니다.")
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    func cancelButtonClicked() {
        view.endEditing(true)
        searchService.dataLists.removeAll()
        searchService.itemStart = 1
        if cellIdentifier == .goods {
            reload(.searchKeyword)
        }
    }
    func searchBarBeginEditing() {
        //        collectionView.setContentOffset(.zero, animated: true)
    }
    func sortButtonTapped() {
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

    func sortChanged(sort: SortOption) {
        self.searchService.sortOption = sort
        self.searchService.itemStart = 1
        self.activityIndicator.startAnimating()
        self.searchService.getShoppingData(search: self.searchService.recentSearched ?? "") { isSuccess, err in
            if isSuccess {
                self.reload(.goods)
            } else {
                if err == NetworkErrors.noData {
                    self.alert("데이터가 없습니다. 다른 검색어를 입력해보세요")
                } else {
                    self.alert("네트워크 연결이 끊어졌습니다.")
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

extension SearchViewController: PinterestLayoutDelegate {
    func headerFlexibleHeight(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        return 230
    }
    func collectionView(_ collectionView: UICollectionView, heightForTitleIndexPath indexPath: IndexPath) -> CGFloat {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        let title = searchService.dataLists[indexPath.item].title
        let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        let estimateFrame = NSString(string: title).boundingRect(with: CGSize(width: itemSize, height: 1000), options: .usesLineFragmentOrigin, attributes: attribute, context: nil)

        return estimateFrame.height + view.frame.width*2/3
    }
}

//
//  SearchViewController.swift
//  CoCo
//
//  Created by 이호찬 on 11/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: class {
    func delegateTapKeywordCell(keyword: String)
    func delegateTextDidChanged(_ search: String)
    func delegateCancelButtonTapped()
}

class SearchViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationSearchBar: UISearchBar!
    @IBOutlet weak var sortButton: UIButton!

//    enum CellIdentifier: String {
//        case searchKeyword = "SearchKeywordCell"
//        case goods = "GoodsCell"
//    }
//
//    // MARK: - Private Properties
//    private var cellIdentifier = CellIdentifier.searchKeyword

    // MARK: - Properties
    weak var delegate: SearchViewControllerDelegate?
    var pinterestLayout = PinterestLayout()
    var centerAlignLayout = CenterAlignedCollectionViewFlowLayout()

    let searchService = SearchService(serachCoreData: SearchWordCoreDataManager(),
                                      petCoreData: PetKeywordCoreDataManager(),
                                      network: ShoppingNetworkManager.shared,
                                      algorithm: Algorithm())

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        navigationSearchBar.delegate = self
        searchService.delegate = self

        self.activityIndicator.stopAnimating()
        searchService.fetchRecommandSearchWord {
            self.collectionView.reloadData()
        }
        extendedLayoutIncludesOpaqueBars = true

        let buttonImage = UIImage(named: "list")?.withRenderingMode(.alwaysTemplate)
        sortButton.setImage(buttonImage, for: .normal)
        sortButton.tintColor = #colorLiteral(red: 0.631372549, green: 0.4901960784, blue: 1, alpha: 1)

        collectionView.collectionViewLayout = centerAlignLayout
        navigationView.isHidden = true
        navigationView.alpha = 0

        collectionView.register(UINib(nibName: "GoodsCell", bundle: nil), forCellWithReuseIdentifier: SearchService.CellIdentifier.goods.rawValue)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    // MARK: - IBActions
    @IBAction func actionTappedScreen(_ sender: UITapGestureRecognizer) {
        // delegate 가 탭 제스쳐와 겹쳐서 DidSelectItemAt 대신 사용
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            switch searchService.cellIdentifier {
            case .searchKeyword:
                guard let cell = self.collectionView?.cellForItem(at: indexPath) as? SearchKeywordCollectionViewCell else {
                    return
                }
                let search = cell.titleLabel.text ?? ""
                navigationSearchBar.text = search
                self.activityIndicator.startAnimating()
                delegate?.delegateTapKeywordCell(keyword: search)
                self.searchService.searchButtonClicked(search)
            case .goods:
                performSegue(withIdentifier: "searchToWeb", sender: indexPath)
            }
        } else {
            view.endEditing(true)
        }
    }
    @IBAction func actionChangeSortRule(_ sender: UIButton) {
        addSortActionSheet()
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
        switch searchService.cellIdentifier {
        case .searchKeyword:
            return searchService.keyword.count
        case .goods:
            return searchService.dataLists.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: searchService.cellIdentifier.rawValue, for: indexPath)
        switch searchService.cellIdentifier {
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
        switch searchService.cellIdentifier {
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
        if scrollView.contentOffset.y > 210 {
            UIView.transition(with: navigationView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.navigationView.isHidden = false
                self.navigationView.alpha = 1
            }, completion: nil)
        } else {
            UIView.transition(with: navigationView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.navigationView.alpha = 0
            }, completion: { finished in
                if finished {
                    self.navigationView.isHidden = true
                }
            })
        }
        if searchService.cellIdentifier == .goods, scrollPosition > 0, scrollPosition < scrollView.contentSize.height * 0.1 {
            searchService.pagination()
        }
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch searchService.cellIdentifier {
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
        switch searchService.cellIdentifier {
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

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchButtonClicked(searchBar.text ?? "")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
        searchBar.setShowsCancelButton(false, animated: true)
        delegate?.delegateCancelButtonTapped()
        cancelButtonClicked()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.delegateTextDidChanged(searchText)
    }
}

extension SearchViewController: SearchCollectionReusableViewDelegate {
    func delegateTextDidChanged(_ search: String) {
        navigationSearchBar.text = search
    }
    func delegateSearchButtonClicked(_ search: String) {
        navigationSearchBar.text = search
        searchButtonClicked(search)
    }
    func searchButtonClicked(_ search: String) {
        view.endEditing(true)
        self.activityIndicator.startAnimating()
        searchService.searchButtonClicked(search)
    }
    func delegateCancelButtonClicked() {
        cancelButtonClicked()
    }
    func cancelButtonClicked() {
        view.endEditing(true)
        searchService.cancelButtonClicked()
    }
    func delegateSortButtonTapped() {
        addSortActionSheet()
    }
    func addSortActionSheet() {
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
        activityIndicator.startAnimating()
        searchService.sortChanged(sort: sort)
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

extension SearchViewController: SearchServiceDelegate {

    func delegateFailToLoad(error: NetworkErrors?) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
        if error == NetworkErrors.noData {
            self.alert("데이터가 없습니다. 다른 검색어를 입력해보세요")
        } else {
            self.alert("네트워크 연결이 끊어졌습니다.")
        }
    }

    func delegateReload(_ cellIdentifier: SearchService.CellIdentifier) {
        if searchService.itemStart > 20 {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.pinterestLayout.setCellPinterestLayout(indexPathRow: self.searchService.itemStart - 21) {
                    self.collectionView.reloadData()
                    self.searchService.isInserting = false
                }
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.searchService.cellIdentifier = cellIdentifier
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
                if cellIdentifier == .goods {
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
    }
}

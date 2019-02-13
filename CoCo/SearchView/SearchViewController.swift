//
//  SearchViewController.swift
//  CoCo
//
//  Created by 이호찬 on 11/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate {
    func tapKeywordCell(keyword: String)
}

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    enum CellIdentifier: String {
        case searchKeyword = "SearchKeywordCell"
        case goods = "GoodsCell"

        var layout: UICollectionViewLayout {
            switch self {
            case .searchKeyword:
                return CenterAlignedCollectionViewFlowLayout()
            case .goods:
                return UICollectionViewFlowLayout()
            }
        }
    }

    var cellIdentifier = CellIdentifier.searchKeyword
    var delegate: SearchViewControllerDelegate?

    let searchService = SearchService(network: ShoppingNetworkManager.shared)

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.collectionViewLayout = cellIdentifier.layout

        collectionView.register(UINib(nibName: "GoodsCell", bundle: nil), forCellWithReuseIdentifier: CellIdentifier.goods.rawValue)
        // Do any additional setup after loading the view.
    }

    @IBAction func actionTappedScreen(_ sender: UITapGestureRecognizer) {
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            guard let cell = self.collectionView?.cellForItem(at: indexPath) as? SearchKeywordCollectionViewCell else {
                return
            }
            switch cellIdentifier {
            case .searchKeyword:
                let search = cell.titleLabel.text ?? ""
                print(search)
                delegate?.tapKeywordCell(keyword: search)
                searchService.getShoppingData(search: search) { isSuccess, _ in
                    if isSuccess {
                        DispatchQueue.main.async {
                            self.cellIdentifier = CellIdentifier.goods
                            self.collectionView.reloadData()
                            self.collectionView.collectionViewLayout = self.cellIdentifier.layout
                        }
                    }
                }
            case .goods:
                print("asdasd")
            }
        } else {
            view.endEditing(true)
        }
    }
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func getShoppingApi(search: String, sort: SortOption) {
        searchService.getShoppingData(search: search) { isSuccess, err in
            if isSuccess {
                DispatchQueue.main.async {
                    self.cellIdentifier = CellIdentifier.goods
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout = self.cellIdentifier.layout
                }
            } else {
                print(err)
            }
        }
    }

}

extension SearchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch cellIdentifier {
        case .searchKeyword:
            return searchService.keyword.count
        case .goods:
            return searchService.dataList.count
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
            if iii > searchService.colorChips.count - 1 {
                iii -= searchService.colorChips.count
            }

            cell.colorBackgroundView.backgroundColor = searchService.colorChips[iii]
            return cell
        case .goods:
            guard let cell = collectionViewCell as? GoodsCell else {
                return UICollectionViewCell()
            }
            cell.myGoods = searchService.dataList[indexPath.row]

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchCollectionReusableView", for: indexPath) as? SearchCollectionReusableView else {
            return UICollectionReusableView()
        }
        if cellIdentifier == .searchKeyword {
            header.sortButton.isHidden = true
        } else {
            header.sortButton.isHidden = false
        }

        header.delegate = self
        self.delegate = header

        return header
    }
}

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch cellIdentifier {
        case .searchKeyword:
            let search = searchService.keyword[indexPath.row]
            print(search)
            delegate?.tapKeywordCell(keyword: search)
            searchService.getShoppingData(search: search) { isSuccess, _ in
                if isSuccess {
                    DispatchQueue.main.async {
                        self.cellIdentifier = CellIdentifier.goods
                        self.collectionView.reloadData()
                        self.collectionView.collectionViewLayout = self.cellIdentifier.layout
                    }
                }
            }
        case .goods:
            print("asdasd")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: view.frame.width, height: 230)
    }

    // SrcollDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
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
//            let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
            collectionView.autoresizingMask = .flexibleHeight
//            return CGSize(width: itemSize, height: itemSize + 50)
            return size(for: indexPath)
        }
    }
    private func size(for indexPath: IndexPath) -> CGSize {
        // load cell from Xib
        guard let cell = Bundle.main.loadNibNamed("GoodsCell", owner: self, options: nil)?.first as? GoodsCell else { return .zero}

        // configure cell with data in it
        cell.myGoods = searchService.dataList[indexPath.row]

        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        // width that you want
        let width = collectionView.frame.width / 2 - 15
        let height: CGFloat = width + 30

        let targetSize = CGSize(width: width, height: height)

        // get size with width that you want and automatic height
        let size = cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel)
        // if you want height and width both to be dynamic use below
        // let size = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)

        return size
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
        searchService.dataList.removeAll()
        searchService.getShoppingData(search: search) { isSuccess, _ in
            if isSuccess {
                DispatchQueue.main.async {
                    self.cellIdentifier = CellIdentifier.goods
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout = self.cellIdentifier.layout
                }
            }
        }
    }

    func cancelButtonClicked() {
        view.endEditing(true)
        searchService.dataList.removeAll()
        if cellIdentifier == .goods {
            self.cellIdentifier = CellIdentifier.searchKeyword
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout = cellIdentifier.layout
        }
    }

    func searchBarBeginEditing() {
//        collectionView.setContentOffset(.zero, animated: true)
    }

    func sortButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: "정렬 방식을 선택해주세요", preferredStyle: .actionSheet)

        let sortSim = UIAlertAction(title: "유사도순", style: .default) { _ in
            self.searchService.sortOption = .similar
        }
        let sortAscending = UIAlertAction(title: "가격 오름차순", style: .default) { _ in
            self.searchService.sortOption = .ascending
        }
        let sortDescending = UIAlertAction(title: "가격 내림차순", style: .default) { _ in
            self.searchService.sortOption = .descending
        }
        let sortDate = UIAlertAction(title: "날짜순", style: .default) { _ in
            self.searchService.sortOption = .date
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionSheet.addAction(sortSim)
        actionSheet.addAction(sortAscending)
        actionSheet.addAction(sortDescending)
        actionSheet.addAction(sortDate)
        actionSheet.addAction(cancel)

        present(actionSheet, animated: true, completion: nil)
    }
}

//extension SearchViewController: PinterestLayoutDelegate {
//    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
//        if cellIdentifier == .goods {
//            guard let image =  else {
//                return 0
//            }
//            return image.size.height
//        }
//    }
//}

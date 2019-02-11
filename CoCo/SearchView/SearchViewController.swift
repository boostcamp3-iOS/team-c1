//
//  SearchViewController.swift
//  CoCo
//
//  Created by 이호찬 on 11/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sortButton: UIButton!

    enum CellIdentifier: String {
        case searchKeyword = "searchKeywordCell"
        case goods = "goodsCell"
    }

    var cellIdentifier = CellIdentifier.searchKeyword

    var keyword = ["", ""]

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch cellIdentifier {
        case .searchKeyword:
            return keyword.count
        case .goods:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier.rawValue, for: indexPath)
        switch cellIdentifier {
        case .searchKeyword:
            guard let cell = collectionViewCell as? SearchKeywordCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        case .goods:
            return UICollectionViewCell()
        }
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cellIdentifier {
        case .searchKeyword:
            let text = keyword[indexPath.row] as NSString
            let length = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]).width + 32

            return CGSize(width: length, height: 32)
        case .goods:
            return CGSize(width: 0, height: 0)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {

}

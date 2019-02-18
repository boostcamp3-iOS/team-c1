//
//  SearchCollectionReusableView.swift
//  CoCo
//
//  Created by 이호찬 on 12/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

protocol SearchCollectionReusableViewDelegate: class {
    func searchButtonClicked(_ search: String)
    func cancelButtonClicked()
    func searchBarBeginEditing()
    func sortButtonTapped()
}

class SearchCollectionReusableView: UICollectionReusableView {
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortButton: UIButton!

    // MARK: - Properties
    weak var delegate: SearchCollectionReusableViewDelegate?

    // MARK: - LifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBar.delegate = self

        let buttonImage = UIImage(named: "list")?.withRenderingMode(.alwaysTemplate)
        sortButton.setImage(buttonImage, for: .normal)
        sortButton.tintColor = #colorLiteral(red: 0.631372549, green: 0.4901960784, blue: 1, alpha: 1)

        // 서치바 폰트 조절하기
//        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
//        textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.

    }

    // MARK: - IBActions
    @IBAction func actionChangeSortRule(_ sender: UIButton) {
        delegate?.sortButtonTapped()
    }
}

extension SearchCollectionReusableView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        delegate?.searchButtonClicked(searchBar.text ?? "")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
        searchBar.setShowsCancelButton(false, animated: true)
        delegate?.cancelButtonClicked()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        delegate?.searchBarBeginEditing()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension SearchCollectionReusableView: SearchViewControllerDelegate {
    func tapKeywordCell(keyword: String) {
        searchBar.text = keyword
    }
}

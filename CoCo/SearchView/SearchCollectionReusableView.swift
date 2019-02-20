//
//  SearchCollectionReusableView.swift
//  CoCo
//
//  Created by 이호찬 on 12/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

protocol SearchCollectionReusableViewDelegate: class {
    func delegateSearchButtonClicked(_ search: String)
    func delegateCancelButtonClicked()
    func delegateSortButtonTapped()
    func delegateTextDidChanged(_ search: String)
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
        delegate?.delegateSortButtonTapped()
    }
}

extension SearchCollectionReusableView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        delegate?.delegateSearchButtonClicked(searchBar.text ?? "")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
        searchBar.setShowsCancelButton(false, animated: true)
        delegate?.delegateCancelButtonClicked()
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

extension SearchCollectionReusableView: SearchViewControllerDelegate {
    func delegateTextDidChanged(_ search: String) {
        searchBar.text = search
    }
    func delegateTapKeywordCell(keyword: String) {
        searchBar.text = keyword
    }
    func delegateCancelButtonTapped() {
        searchBar.text?.removeAll()
    }
}

//
//  MyGoodsViewController.swift
//  CoCo
//
//  Created by 최영준 on 11/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

class MyGoodsViewController: UIViewController {
    // TODO: - 나중에 서비스 클래스에서 처리
    var recentGoods = [MyGoodsData]()
    var favoriteGoods = [MyGoodsData]()

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setNavigationBar()
    }

    // MARK: - Navigation related methods
    func setNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "내 상품"
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editCell))
        editButton.tintColor = AppColor.purple
        navigationItem.rightBarButtonItem = editButton
    }

    @objc func editCell() {
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MyGoodsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewCell.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.myGoodsTableViewCell) as? MyGoodsTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row == TableViewCell.recentRow {
            cell.titleLable.text = "최근 본 상품"
            cell.updateContents(recentGoods)
        } else if indexPath.row == TableViewCell.favoriteRow {
            cell.titleLable.text = "찜한 목록"
            cell.updateContents(favoriteGoods)
        }
        return cell
    }
}

// MARK: - Private structures
extension MyGoodsViewController {
    private struct TableViewCell {
        static let recentRow = 0
        static let favoriteRow = 1
        static let count = 2
    }

    private struct TableViewCellIdentifier {
        static let myGoodsTableViewCell = "MyGoodsTableViewCell"
    }
}

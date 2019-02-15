//
//  MyGoodsViewController.swift
//  CoCo
//
//  Created by 최영준 on 11/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

class MyGoodsViewController: UIViewController {
    // MARK: - Private properties
    private var service: MyGoodsService?
    private var enableEditing = false

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - View lifecycles & override methods
    override func viewDidLoad() {
        service = MyGoodsService()
        setNavigationBar()
        setTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        service?.fetchGoods()
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == Identifier.goToWebViewSegue {
            guard let webVC = segue.destination as? WebViewController,
                let myGoodsData = sender as? MyGoodsData else {
                    let message = getErrorMessage(MyGoodsDataError.lostData)
                    alert(message)
                    return
            }
            webVC.sendData(myGoodsData)
        }
    }

    // MARK: - Navigation related methods
    private func setNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "내 상품"
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(startEditing))
        editButton.tintColor = AppColor.purple
        navigationItem.rightBarButtonItem = editButton
    }

    // MARK: - TalbeView related methods
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc private func startEditing() {
        enableEditing = !enableEditing
        tableView.reloadData()
    }

    // MARK: - CollectionView related methods
    @objc func deleteAction(_ sender: UIButton) {
        let index = sender.tag
        // 최근 본 상품
        if index < 10, let data = service?.recentGoods[safeIndex: index] {
            service?.deleteRecentGoods(data)
        // 찜한 목록
        } else if let data = service?.favoriteGoods[safeIndex: index - 10] {
            service?.deleteFavoriteGoods(data)
        }
        service?.fetchGoods()
        tableView.reloadData()
    }

    func performSegue(withData data: MyGoodsData) {
        performSegue(withIdentifier: Identifier.goToWebViewSegue, sender: data)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MyGoodsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.myGoodTableViewCell) as? MyGoodsTableViewCell, let service = service else {
            return UITableViewCell()
        }
        cell.delegate = self
        DispatchQueue.main.async {
            let (text, data, tag) = (indexPath.section == Section.recent) ?
                ("최근 본 상품", service.recentGoods, indexPath.row) : ("찜한 목록", service.favoriteGoods, 10 + indexPath.row)
            cell.tag = tag
            cell.titleLabel.text = text
            cell.updateContents(data)
        }
        return cell
    }
}

// MARK: - ErrorHandlerType
extension MyGoodsViewController: ErrorHandlerType { }

// MARK: - MyGoodsDataDelegate
extension MyGoodsViewController: MyGoodsDataDelegate {
    func receiveData(_ data: MyGoodsData) {
        performSegue(withData: data)
    }

    func receiveSender(_ sender: Any) {
        if let button = sender as? UIButton {
            button.isHidden = !enableEditing
            button.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        }
    }
}

// MARK: - Private structures
extension MyGoodsViewController {
    private struct Identifier {
        static let myGoodTableViewCell = "MyGoodsTableViewCell"
        static let webViewController = "WebViewController"
        static let goToWebViewSegue = "GoToWebViewController"
    }

    private struct Section {
        static let recent = 0
        static let favorite = 1
    }
}

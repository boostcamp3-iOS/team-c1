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
    private var enableEditing = false
    // TODO: 데이터를 서비스 클래스에 포함 시킨다.
    private var recentGoods = [MyGoodsData]()
    private var favoriteGoods = [MyGoodsData]()

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - View lifecycles & override methods
    override func viewDidLoad() {
        setNavigationBar()
        setTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: 서비스에서 데이터를 불러오는 작업을 작성한다.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == Identifier.goToWebViewSegue {
            guard let webVC = segue.destination as? WebViewController, let myGoodsData = sender as? MyGoodsData else {
                let message = getErrorMessage(MyGoodsDataError.lostData)
                alert(message)
                return
            }
            webVC.myGoodsData = myGoodsData
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
    @objc func deleteData() {
        // TODO: 서비스 클래스에서 삭제 처리 로직 구현
    }

    func performSegue(withData data: MyGoodsData) {
        performSegue(withIdentifier: Identifier.goToWebViewSegue, sender: data)
    }
}

// MARK: - ErrorHandlerType
extension MyGoodsViewController: ErrorHandlerType { }

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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.myGoodTableViewCell) as? MyGoodsTableViewCell else {
            return UITableViewCell()
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            let (text, data) = (indexPath.section == Section.recent) ?
                ("최근 본 상품", self.recentGoods) : ("찜한 목록", self.favoriteGoods)
            cell.titleLabel.text = text
            cell.startEditing(self.enableEditing, target: self, delete: #selector(self.deleteData))
            cell.updateContents(data, viewController: self)
        }
        return cell
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

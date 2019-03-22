//
//  MyGoodsViewController.swift
//  CoCo
//
//  Created by 최영준 on 11/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

/**
 최근 본 상품, 좋아요 누른 상품을 확인 또는 삭제할 수 있는 컨트롤러
 
 - Author: [최영준](https://github.com/0jun0815)
 */
class MyGoodsViewController: UIViewController {
    // MARK: - Private properties
    private var service: MyGoodsService?

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - View lifecycles & override methods
    override func viewDidLoad() {
        setTableView()
        extendedLayoutIncludesOpaqueBars = true
        setNavigationBar()
        let manager = MyGoodsCoreDataManager()
        service = MyGoodsService(manager: manager)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        service?.fetchGoods { [weak self] (error) in
            if let error = error {
                print(error)
            }
            self?.reloadTableView()
        }
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

    func performSegue(withData data: MyGoodsData) {
        performSegue(withIdentifier: Identifier.goToWebViewSegue, sender: data)
    }

    // MARK: - Navigation related methods
    private func setNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "내 상품"
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(startEditing))
        editButton.tintColor = AppColor.purple
        navigationItem.rightBarButtonItem = editButton
    }

    // MARK: - TalbeView related methods
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.tableView.reloadData()
            let topIndexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
        }
    }

    // MARK: - Action methods
    @objc private func startEditing() {
        guard let service = service, let barButtonItem = navigationItem.rightBarButtonItem,
            !service.dataIsEmpty else {
                return
        }
        barButtonItem.isEnabled = !barButtonItem.isEnabled
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            barButtonItem.isEnabled = !barButtonItem.isEnabled
        }
        service.startEditing = !service.startEditing
        barButtonItem.title = (service.startEditing) ? "Done" : "Edit"
        reloadTableView()
    }

    @objc func deleteAction(_ sender: UIButton) {
        guard let service = service else {
            return
        }
        let index = sender.tag
        service.deleteGoods(index: index) { [weak self] in
            guard let self = self else { return }
            service.fetchGoods { (error) in
                if let error = error {
                    print(error)
                }
                DispatchQueue.main.async {
                    if service.dataIsEmpty, let item = self.navigationItem.rightBarButtonItem {
                        item.title = "Edit"
                        service.startEditing = false
                    }
                    self.reloadTableView()
                }
            }
        }
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
        let contentsCellWidth = Double((view.frame.size.width - 40) / 2)
        // 각 셀 내부 뷰들의 레이아웃 간격 및 높이 계산한 값
        let contentsCellHeight = contentsCellWidth + 10 + 25 + 10 + (3 + 35 + 3 + 20 + 5 + 5 + 20 + 5) + 10 + 5
        return CGFloat(contentsCellHeight)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.myGoodTableViewCell) as? MyGoodsTableViewCell, let service = service else {
            return UITableViewCell()
        }
        cell.delegate = self
        let (text, data, tag) = (indexPath.section == Section.recent) ?
            ("최근 본 상품", service.recentGoods, indexPath.row) : ("찜한 목록", service.favoriteGoods, 10 + indexPath.row)
        cell.tag = tag
        cell.titleLabel.text = text
        cell.updateContents(data)
        return cell
    }
}

// MARK: - ErrorHandlerType
extension MyGoodsViewController: ErrorHandlerType { }

// MARK: - MyGoodsDataDelegate
extension MyGoodsViewController: MyGoodsDataDelegate {
    func receiveData(_ data: MyGoodsData) {
        guard let service = service, !service.startEditing else {
            return
        }
        performSegue(withData: data)
    }

    func receiveSender(_ sender: Any) {
        guard let service = service else {
            return
        }
        if let button = sender as? UIButton {
            button.isHidden = !service.startEditing
            button.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        } else if let view = sender as? UIVisualEffectView {
            view.isHidden = !service.startEditing
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
        static let indexSet = IndexSet(integersIn: recent ... favorite)
        static let recent = 0
        static let favorite = 1
    }
}

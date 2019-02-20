//
//  SettingViewController.swift
//  CoCo
//
//  Created by 이호찬 on 16/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

protocol SettingPetKeywordDelegate: class {
    func changePet()
}

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let settingSectionTitles = ["유저정보", "메모리", "기타"]
    let settingTitles: [[String]] = [["나의 펫", "관심 키워드"], ["캐시 데이터 지우기"], ["서비스 이용약관", "API 정보"]]
    let cellIdentifier = "SettingTableViewCell"

    enum segueIdentifier: String {
        case petKeyword = "SettingToPetKeyword"
        case privacy = "SettingToPrivacyPolicy"
        case apiInfo = "SettingToAPI"
    }

    weak var settingPetKeywordDelegate: SettingPetKeywordDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        settingPetKeywordDelegate?.changePet()
        print("didappear")
    }

    func deleteCache() {
        let cacheSize = ImageManager.shared.getCacheSize()
        let alert = UIAlertController(title: "정말 캐시 데이터를 지우시겠습니까?", message: "\(Int(cacheSize/100))MB의 메모리가 확보됩니다.", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { _ in
            ImageManager.shared.removeAll()
        }
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)

        alert.addAction(yes)
        alert.addAction(no)

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingPetAndKeywordViewController: SettingPetAndKeywordViewController = segue.destination as? SettingPetAndKeywordViewController else {
            return
        }
        guard let sender = sender as? Int else {
            return
        }
        if sender == 0 {
            settingPetAndKeywordViewController.segue = SettingPetAndKeywordViewController.checkSegue.pet
        } else {
            settingPetAndKeywordViewController.segue = SettingPetAndKeywordViewController.checkSegue.keyword
        }
        settingPetAndKeywordViewController.headerTitle = settingTitles[0][sender]
    }
}

extension SettingViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return settingSectionTitles.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingSectionTitles[section]
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 {
            return "네이버 쇼핑 API"
        }
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingTitles[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        cell.settingTitleLabel.text = settingTitles[indexPath.section][indexPath.row]

        if indexPath.section == 1 {
            cell.accessoryType = .none
        } else if indexPath.section == 2 && indexPath.row == 1 {
            cell.accessoryType = .none
        }

        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: segueIdentifier.petKeyword.rawValue, sender: indexPath.row)
        case 1:
            deleteCache()
        case 2:
            if indexPath.row == 0 {
                performSegue(withIdentifier: segueIdentifier.privacy.rawValue, sender: nil)
            }
        default:
            break
        }
    }
}

//
//  SettingViewController.swift
//  CoCo
//
//  Created by 이호찬 on 16/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let settingSectionTitles = ["유저정보", "메모리", "기타"]
    let settingTitles: [[String]] = [["나의 펫", "관심 키워드"], ["캐시 데이터 지우기"], ["서비스 이용약관", "API 정보"]]
    let cellIdentifier = "SettingTableViewCell"

    enum segueIdentifier: String {
        case pet = "SettingToPet"
        case keyword = "SettingToKeyword"
        case cache = "SettingToCache"
        case privacy = "SettingToPrivacy"
        case apiInfo = "SettingToAPI"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

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

extension SettingViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return settingSectionTitles.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingSectionTitles[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingTitles[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        cell.settingTitleLabel.text = settingTitles[indexPath.section][indexPath.row]

        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        switch indexPath.section {
//        case 0:
//            performSegue(withIdentifier: segueIdentifier.pet.rawValue, sender: <#T##Any?#>)
//        case 1:
//
//        case 2:
//
//        default:
//
//    }
    }
}

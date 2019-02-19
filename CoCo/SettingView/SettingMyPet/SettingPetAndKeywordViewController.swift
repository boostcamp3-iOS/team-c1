//
//  SettingMyPetViewController.swift
//  CoCo
//
//  Created by 이호찬 on 18/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import UIKit

class SettingPetAndKeywordViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    enum checkSegue {
        case pet
        case keyword
    }

    var segue = checkSegue.pet
    var headerTitle: String?

    let settingPetAndKeywordService = SettingPetAndKeywordService(petCoreData: PetKeywordCoreDataManager())
    let cellIdentifier = "SettingPetAndKeywordTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        settingPetAndKeywordService.fetchPetKeywordData()

        switch segue {
        case .pet:
            print("pet")
        case .keyword:
            print("keyword")
        }

        navigationController?.navigationBar.prefersLargeTitles = false
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        settingPetAndKeywordService.insertPetKeywordData()
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

extension SettingPetAndKeywordViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitle
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segue {
        case .pet:
            return settingPetAndKeywordService.petDic.count
        case .keyword:
            return settingPetAndKeywordService.keywordDic.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingPetAndKeywordTableViewCell else {
            return UITableViewCell()
        }
        switch segue {
        case .pet:
            cell.petKeywordLabel.text = settingPetAndKeywordService.petDic[indexPath.row]
            cell.accessoryType = .none
            settingPetAndKeywordService.petDic.forEach { index, pet in
                if indexPath.row == index, pet == settingPetAndKeywordService.petKeyword?.pet {
                    cell.accessoryType = .checkmark
                }
            }
        case .keyword:
            cell.petKeywordLabel.text = settingPetAndKeywordService.keywordDic[indexPath.row]
            settingPetAndKeywordService.keywordDic.forEach { index, keyword in
                if indexPath.row == index {
                    for i in settingPetAndKeywordService.petKeyword?.keywords ?? [""] {
                        if i == keyword {
                            cell.accessoryType = .checkmark
                            break
                        } else {
                            cell.accessoryType = .none
                        }
                    }
                }
            }
        }
        return cell
    }
}

extension SettingPetAndKeywordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch segue {
        case .pet:
            settingPetAndKeywordService.petKeyword?.pet = settingPetAndKeywordService.petDic[indexPath.row]
            tableView.reloadData()
        case .keyword:
            var isInclude = false
            var index = 0
            settingPetAndKeywordService.petKeyword?.keywords?.enumerated().forEach { i, keyword in
                if keyword == settingPetAndKeywordService.keywordDic[indexPath.row] {
                    isInclude = true
                    index = i
                }
            }
            if isInclude {
                if settingPetAndKeywordService.petKeyword?.keywords?.count ?? 0 > 5 {
                    settingPetAndKeywordService.petKeyword?.keywords?.remove(at: index)
                }
            } else {
                settingPetAndKeywordService.petKeyword?.keywords?.append(settingPetAndKeywordService.keywordDic[indexPath.row] ?? "")
            }
            tableView.reloadData()
        }
    }
}

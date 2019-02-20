//
//  PetKeywordViewController.swift
//  CoCo
//
//  Created by 최영준 on 19/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import SpriteKit

class PetKeywordViewController: UIViewController {
    // MARK: - Private properties
    private var service = PetKeywordService()

    // MARK: - IBOulets
    @IBOutlet private weak var animationView: SKView!
    @IBOutlet private weak var completionButton: UIButton!
    @IBOutlet weak var textLabel: UILabel! {
        didSet {
            textLabel.text = "반려동물과 2개 이상의 관심 키워드를\n선택해주세요."
        }
    }

    // MARK: - View lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaults.isFirstLaunch(), let tabBarController = UIStoryboard(name: "Discover", bundle: nil).instantiateViewController(withIdentifier: "tabBarcontroller") as? UITabBarController {
            print("펫키워드 생성여기!!!")
            UIApplication.shared.keyWindow?.rootViewController = tabBarController
        }
        service.setAnimation(in: animationView, delegate: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        service.startAnimation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        service.removeAnimation()
    }

    // MARK: - IBAction
    @IBAction func completionAction(_ sender: UIButton) {
        if let tabBarController = UIStoryboard(name: "Discover", bundle: nil).instantiateViewController(withIdentifier: "tabBarcontroller") as? UITabBarController {
            if UserDefaults.isFirstLaunch() {
                UserDefaults.standard.set(true, forKey: UserDefaults.launchedBefore)
            }
            service.insertPetKeyword()
            UIApplication.shared.keyWindow?.rootViewController = tabBarController
        }
    }
}

// MARK: - AnimationType
extension PetKeywordViewController: AnimationType {
    func animation(_ animation: Animation, didSelect node: AnimationNode) {
        if let petNode = service.getSelectedPetNode(), let name = petNode.name {
            service.pet = Pet(rawValue: name)
        }
        if service.getSelectedNodes().count >= 2,
            let _ = service.getSelectedPetNode() {
            completionButton.isEnabled = true
            textLabel.text = "서비스를 시작할 수 있습니다."
        } else if service.getSelectedNodes().count >= 2 {
            completionButton.isEnabled = false
            textLabel.text = "반려동물을 선택해주세요."
        } else if let _ = service.getSelectedPetNode() {
            completionButton.isEnabled = false
            textLabel.text = "2개 이상의 관심 키워드를 선택해주세요."
        } else {
            completionButton.isEnabled = false
            textLabel.text = "반려동물과 2개 이상의 관심 키워드를\n선택해주세요."
        }
    }

    func animation(_ animation: Animation, didDeselect node: AnimationNode) {
        if let _ = service.getSelectedPetNode(), service.getSelectedNodes().count < 2 {
            completionButton.isEnabled = false
            textLabel.text = "2개 이상의 관심 키워드를 선택해주세요."
        } else if service.getSelectedNodes().count < 2 {
            completionButton.isEnabled = false
            textLabel.text = "반려동물과 2개 이상의 관심 키워드를\n선택해주세요."
        } else {
            completionButton.isEnabled = false
            textLabel.text = "반려동물을 선택해주세요."
        }
    }
}

// MARK: - ErrorHandlerType
extension PetKeywordViewController: ErrorHandlerType { }

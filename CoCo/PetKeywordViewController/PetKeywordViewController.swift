//
//  PetKeywordViewController.swift
//  CoCo
//
//  Created by 최영준 on 19/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import SpriteKit

/**
 펫, 키워드 선택을 위한 컨트롤러, 애니메이션 동작으로 사용자의 선택을 돕는다.
 
 앱 최초 실행시 호출되며 선택이 완료되면 Discover 페이지로 전환된다.
 
 - Author: [최영준](https://github.com/0jun0815)
 */
class PetKeywordViewController: UIViewController {
    // MARK: - Private properties
    private var service = PetKeywordService()
    
    // MARK: - IBOulets
    @IBOutlet private weak var animationView: SKView!
    @IBOutlet private weak var completionButton: UIButton!
    @IBOutlet private weak var textLabel: UILabel! {
        didSet {
            textLabel.text = "반려동물과 2개 이상의 관심 키워드를\n선택해주세요."
        }
    }
    
    // MARK: - View lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
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
        // 반려동물 선택은 1개만 가능하다. 이미 선택되었을 경우 이전 노드를 해제시키고 새로운 노드로 변경한다.
        if let petNode = service.getSelectedPetNode(), let name = petNode.name {
            service.pet = Pet(rawValue: name)
        }
        // 선택에 따른 textLabel 변경
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
        // 선택 해제에 따른 textLabel 변경
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

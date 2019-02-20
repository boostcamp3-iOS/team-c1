//
//  KeywordViewController.swift
//  CoCo
//
//  Created by 최영준 on 19/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import SpriteKit

class KeywordViewController: UIViewController {
    // MARK: - Private properties
    private var service: KeywordService?

    // MARK: - IBOulets
    @IBOutlet private var animationView: SKView!
    @IBOutlet weak var completionButton: UIButton! {
        didSet {
            print("설정됌")
            completionButton.isEnabled = false
            completionButton.titleLabel?.textAlignment = .center
        }
    }

    // MARK: - Required call methods
    // 데이터를 전달한다. (필수)
    func sendData(_ data: Pet) {
        service = KeywordService(pet: data)
    }

    // MARK: - View lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        service?.setAnimation(in: animationView, delegate: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        setNavigationBar()
        service?.startAnimation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        service?.removeAnimation()
    }

    // MARK: - Navigation related methods
    private func setNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        let backButton = UIBarButtonItem(image: UIImage(named: "left-arrow"), style: .plain, target: self, action: #selector(popViewController))
        backButton.tintColor = AppColor.purple
        navigationItem.leftBarButtonItem = backButton
        navigationItem.hidesBackButton = true
    }

    @objc private func popViewController() {
        navigationController?.popViewController(animated: false)
    }

    // MARK: - IBAction
    @IBAction func completionAction(_ sender: UIButton) {
        if let tabBarController = UIStoryboard(name: "Discover", bundle: nil).instantiateViewController(withIdentifier: "tabBarcontroller") as? UITabBarController {
            if UserDefaults.isFirstLaunch() {
                UserDefaults.standard.set(true, forKey: UserDefaults.launchedBefore)
            }
            service?.insertPetKeyword()
            UIApplication.shared.keyWindow?.rootViewController = tabBarController
        }
    }
}

// MARK: - AnimationType
extension KeywordViewController: AnimationType {
    func animation(_ animation: Animation, didSelect node: AnimationNode) {
        if let count = service?.getSelectedNodes().count, count >= 2 {
            completionButton.isEnabled = true
            completionButton.setTitle("서비스를 시작할 수 있습니다.", for: .normal)
        }
    }

    func animation(_ animation: Animation, didDeselect node: AnimationNode) {
        if let count = service?.getSelectedNodes().count, count < 2 {
            completionButton.isEnabled = false
            completionButton.setTitle("2개 이상의 관심 키워드를 선택해주세요.", for: .normal)
        }
    }
}

// MARK: - ErrorHandlerType
extension KeywordViewController: ErrorHandlerType { }

//
//  PetKeywordService.swift
//  CoCo
//
//  Created by 최영준 on 19/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import SpriteKit

/**
 PetKeywordViewController를 위한 서비스 클래스
 
 사용자 관심 반려동물과 키워드를 코어데이터에 저장하며 애니메이션 동작을 처리한다.
 
 - Author: [최영준](https://github.com/0jun0815)
 */
class PetKeywordService {
    var pet: Pet?
    private var manager: PetKeywordCoreDataManagerType?
    private var animation: Animation?
    private var keywords: [Keyword] {
        let keywords = Keyword.allCases
        return keywords.shuffled()
    }
    private var colors: [UIColor] {
        return AppColor.list
    }
    
    init(manager: PetKeywordCoreDataManagerType) {
        self.manager = manager
    }
    
    /// 애니메이션 관련 설정 메서드
    func setAnimation(in view: SKView, delegate: AnimationType) {
        let scene = Animation(size: view.bounds.size)
        view.presentScene(scene)
        animation = scene
        animation?.animationDelegate = delegate
    }
    /// 애니메이션을 시작한다.
    func startAnimation() {
        // 펫 노드들을 추가
        for pet in Pet.allCases {
            let image = (pet == .dog) ?
                UIImage(imageLiteralResourceName: "dogcolor") :
                UIImage(imageLiteralResourceName: "catcolor")
            let index = Int.random(in: 0 ..< colors.count)
            let node = AnimationNode(name: pet.rawValue, fillColor: colors[index], image: image)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.animation?.addChildPetNode(node)
            }
        }
        // 키워드 노드들을 추가
        for keyword in keywords {
            let index = Int.random(in: 0 ..< colors.count)
            let node = AnimationNode(text: keyword.rawValue, fillColor: colors[index])
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.animation?.addChild(node)
            }
        }
    }
    /// 선택된 노드 리스트를 가져온다
    func getSelectedNodes() -> [SKNode] {
        if let selectedNodes = animation?.selectedNodes {
            return selectedNodes
        }
        return []
    }
    /// 선택된 펫 노드들을 가져온다
    func getSelectedPetNode() -> SKNode? {
        if let node = animation?.petNodes.filter({ $0.isSelected }).first {
            return node
        }
        return nil
    }
    
    func removeAnimation() {
        animation?.removeAllChildren()
    }
    /// 코어데이터에 펫, 키워드를 추가한다.
    @discardableResult func insertPetKeyword() -> Bool {
        guard let pet = pet, let manager = manager else {
            return false
        }
        var selectedKeywords = [String]()
        for node in getSelectedNodes() {
            if let name = node.name, let _ = Keyword(rawValue: name) {
                selectedKeywords.append(name)
            }
        }
        let petKeywordData = PetKeywordData(pet: pet.rawValue, keywords: selectedKeywords)
        if let result = try? manager.insert(petKeywordData) {
            return result
        }
        return false
    }
}

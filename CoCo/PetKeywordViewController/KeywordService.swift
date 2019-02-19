//
//  KeywordService.swift
//  CoCo
//
//  Created by 최영준 on 19/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import SpriteKit

class KeywordService {
    private lazy var manager = PetKeywordCoreDataManager()
    private var animation: Animation?
    private var pet: Pet?
    private var keywords: [Keyword] {
        let keywords = Keyword.allCases
        return keywords.shuffled()
    }
    private var colors: [UIColor] {
        return AppColor.list
    }

    init(pet: Pet) {
        self.pet = pet
    }

    func setAnimation(in view: SKView, delegate: AnimationType) {
        let scene = Animation(size: view.bounds.size)
        view.presentScene(scene)
        animation = scene
        animation?.animationDelegate = delegate
    }

    func startAnimation() {
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

    func getSelectedNodes() -> [SKNode] {
        if let selectedNodes = animation?.selectedNode {
            return selectedNodes
        }
        return []
    }

    func removeAnimation() {
        animation?.removeAllChildren()
    }

    @discardableResult func insertPetKeyword() -> Bool {
        guard let pet = pet else {
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

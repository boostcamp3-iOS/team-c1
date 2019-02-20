//
//  PetKeywordService.swift
//  CoCo
//
//  Created by 최영준 on 19/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import SpriteKit

class PetKeywordService {
    var pet: Pet?
    private lazy var manager = PetKeywordCoreDataManager()
    private var animation: Animation?
    private var keywords: [Keyword] {
        let keywords = Keyword.allCases
        return keywords.shuffled()
    }
    private var colors: [UIColor] {
        return AppColor.list
    }

    func setAnimation(in view: SKView, delegate: AnimationType) {
        let scene = Animation(size: view.bounds.size)
        view.presentScene(scene)
        animation = scene
        animation?.animationDelegate = delegate
    }

    func startAnimation() {
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

    func getSelectedPetNode() -> SKNode? {
        if let node = animation?.petNode.filter({ $0.isSelected }).first {
            return node
        }
        return nil
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

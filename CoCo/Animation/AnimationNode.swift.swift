//
//  AnimationNode.swift
//  CoCo
//
//  Created by 최영준 on 19/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import SpriteKit

class AnimationNode: SKShapeNode {
    var isSelected: Bool = false {
        didSet {
            if isSelected == oldValue {
                return
            }
            selectAnimation(isSelected)
        }
    }
    private(set) var textLabel: SKLabelNode?

    init(text: String?, fillColor: UIColor, radius: CGFloat = 40, lineWidth: CGFloat = 1.0, strokeColor: UIColor = .clear, fontSize: CGFloat = 20, fontColor: UIColor = .white) {
        super.init()
        let path = CGMutablePath()
        path.addArc(center: .zero, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        self.name = text
        self.path = path
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.glowWidth = 0.0
        updatePhycisBody(radius: radius)
        updateTextLable(text: text, fontSize: fontSize, fontColor: fontColor)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func removeFromParent() {
        removeAnimation {
            super.removeFromParent()
        }
    }

    private func updateChildrenNode() {
        removeAllChildren()
        if let textLabel = textLabel {
            addChild(textLabel)
        }
    }

    private func updatePhycisBody(radius: CGFloat) {
        let body = SKPhysicsBody(circleOfRadius: radius)
        // 물리적 충격에 영향을 받는지
        body.allowsRotation = false
        // 물리적 물체끼리 접촉시 마찰력을 가하는 값
        body.friction = 0
        // 물체의 선형 속도를 감소시킨다. 0.0 ~ 1.0 이라지만 더 큰 값도 되는듯?
        body.linearDamping = 3
        physicsBody = body
    }

    func updateTextLable(text: String?, fontSize: CGFloat, fontColor: UIColor?) {
        let label = SKLabelNode(text: text)
        label.fontName = "Avenir-Black"
        label.fontColor = fontColor
        label.fontSize = fontSize
        let y = frame.midY - label.frame.height / 2
        label.position = CGPoint(x: frame.midX, y: y)
        textLabel = label
        updateChildrenNode()
    }

    private func selectAnimation(_ isSelected: Bool) {
        if isSelected {
            // 0.2 초동안 커진다.
            let scale = CGFloat.random(in: 4/3 ... 2)
            run(.scale(to: scale, duration: 0.2))
        } else {
            // 0.2 초동안 작아진다(원래 크기로 돌아옴).
            run(.scale(to: 1, duration: 0.2))
        }
    }

    private func removeAnimation(completion: @escaping () -> Void) {
        run(.fadeOut(withDuration: 0.2), completion: completion)
    }
}

//
//  AnimationNode.swift
//  CoCo
//
//  Created by 최영준 on 19/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import SpriteKit

/**
 Animtion에 사용되는 노드.
 
 이미지 사용 여부를 선택하여 초기화할 수 있다.
 노드 선택 여부에 따라 사이즈를 증가/감소 시킨다.
 - Author: [최영준](https://github.com/0jun0815)
 */
class AnimationNode: SKShapeNode {
    // MARK: - Properties
    /// 선택 여부에 따라 노드의 사이즈를 증가/감소 시킨다.
    var isSelected: Bool = false {
        didSet {
            if isSelected == oldValue {
                return
            }
            selectAnimation(isSelected)
        }
    }
    private(set) var textLabel: SKLabelNode?
    private(set) var imageTexture: SKTexture?

    // MARK: - Initializers
    init(text: String?, fillColor: UIColor, image: UIImage? = nil, radius: CGFloat = 40, lineWidth: CGFloat = 1, strokeColor: UIColor = .clear, fontSize: CGFloat = 20, fontColor: UIColor = .white) {
        super.init()
        let path = CGMutablePath()
        path.addArc(center: .zero, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        self.path = path
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.glowWidth = 0.5
        self.name = text
        updatePhycisBody(radius: radius)
        updateTextLable(text: text, fontSize: fontSize, fontColor: fontColor)
        updateImageTexture(image: image)
    }

    convenience init(name: String, fillColor: UIColor, image: UIImage) {
        self.init(text: name, fillColor: fillColor, image: image, radius: 50)
        textLabel?.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func removeFromParent() {
        removeAnimation {
            super.removeFromParent()
        }
    }

    // MARK: - Set methods
    /// 생성된 textLabel, imageTexture를 추가한다.
    private func updateChildrenNode() {
        removeAllChildren()
        if let textLabel = textLabel {
            addChild(textLabel)
        }
        if let imageTexture = imageTexture {
            let spriteNode = SKSpriteNode(texture: imageTexture)
            spriteNode.size = CGSize(width: frame.width - 10, height: frame.height - 10)
            addChild(spriteNode)
        }
    }
    /// physicsBody를 생성한다.
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
    /// textLabel을 생성한다.
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
    /// imageTexture를 생성한다.
    func updateImageTexture(image: UIImage?) {
        guard let originImage = image,
            let image = resizeImage(originImage, size: frame.size)  else {
                return
        }
        imageTexture = SKTexture(image: image)
        updateChildrenNode()
    }
    /// 이미지 크기를 노드 사이즈에 맞게 리사이즈한다.
    private func resizeImage(_ image: UIImage, size: CGSize) -> UIImage? {
        let ratio = max(size.width / image.size.width, size.height / image.size.height)
        var newSize = image.size
        newSize.width *= ratio
        newSize.height *= ratio
        var rect = CGRect.zero
        rect.size = newSize
        UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    // MARK: Animation methods
    /// 노드 선택여부에 따른 애니메이션 처리(증가/감소)
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
    /// 노드 삭제시 애니메이션
    private func removeAnimation(completion: @escaping () -> Void) {
        run(.fadeOut(withDuration: 0.2), completion: completion)
    }
}

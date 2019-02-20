//
//  Animation.swift
//  CoCo
//
//  Created by 최영준 on 19/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import SpriteKit

protocol AnimationType: class {
    func animation(_ animation: Animation, didSelect node: AnimationNode)
    func animation(_ animation: Animation, didDeselect node: AnimationNode)
}

class Animation: SKScene {
    var isMultipleTouchEnabled: Bool = true
    var selectedNode: [AnimationNode] {
        return children.compactMap { $0 as? AnimationNode }.filter { $0.isSelected }.filter { !petNode.contains($0) }
    }
    var petNode = [AnimationNode]()
    weak var animationDelegate: AnimationType?

    private(set) var fieldNode: SKFieldNode?
    private var strength: Float = 0.0
    private lazy var radius: Float = 0.0
    private var isMoving: Bool = false

    override var size: CGSize {
        didSet {
            setProperties()
        }
    }

    override init(size: CGSize) {
        super.init(size: size)
        scaleMode = .aspectFill
        // 0, -9.8 = 현실 중력, 0, 0 = 화면 가운데 중력
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        backgroundColor = .white
        setProperties()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setProperties() {
        strength = Float(max(size.width, size.height))
        radius = strength.squareRoot() * 100
        updatePhycisBody(rect: self.frame, radius: CGFloat(radius))
        updateFieldNode(strength: strength, radius: radius)
    }

    private func updatePhycisBody(rect: CGRect, radius: CGFloat) {
        var rect = rect
        rect.size.width = radius
        rect.origin.x -= rect.size.width / 2
        physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
    }

    private func updateFieldNode(strength: Float, radius: Float) {
        fieldNode = SKFieldNode.radialGravityField()
        if let fieldNode = fieldNode {
            addChild(fieldNode)
        }
        fieldNode?.region = SKRegion(radius: radius)
        fieldNode?.minimumRadius = radius
        fieldNode?.strength = strength
        fieldNode?.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }

    override func addChild(_ node: SKNode) {
        // 상하 좌우 랜덤으로 등장
        let x = CGFloat.random(in: -node.frame.width ... frame.width + node.frame.width)
        let y = CGFloat.random(in: node.frame.height ... frame.height - node.frame.height)
        node.position = CGPoint(x: x, y: y)
        super.addChild(node)
    }

    func addChildPetNode(_ node: AnimationNode) {
        petNode.append(node)
        addChild(node)
    }
}

// MARK: - Touch events
extension Animation {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        let previous = touch.previousLocation(in: self)
        // hypot은 (x의 제곱 + y의 제곱)의 제곱근이다.
        if hypot(previous.x - location.x, previous.y - location.y) == 0 {
            return
        }
        isMoving = true
        let x = location.x - previous.x
        let y = location.y - previous.y
        for node in children {
            let distance = hypot(location.x - node.position.x, location.y - node.position.y)
            let acceleration: CGFloat = 3 * pow(distance, 1/2)
            let direction = CGVector(dx: x * acceleration, dy: y * acceleration)
            node.physicsBody?.applyForce(direction)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        let animationNodes = nodes(at: location).compactMap { $0 as? AnimationNode }.filter { node -> Bool in
            guard let path = node.path, path.contains(convert(location, to: node)) else {
                return false
            }
            return true
        }
        defer {
            isMoving = false
        }
        guard !isMoving, let node = animationNodes.first else {
            return
        }
        // 펫 노드에 적용
        if petNode.contains(node) {
            for other in petNode {
                if !other.isSelected || other === node {
                    continue
                }
                other.isSelected = false
                animationDelegate?.animation(self, didDeselect: other)
            }
        }
        // 일반 노드에 적용
        if node.isSelected {
            node.isSelected = false
            animationDelegate?.animation(self, didDeselect: node)
        } else if !isMultipleTouchEnabled, let selectedNode = selectedNode.first {
            selectedNode.isSelected = false
            animationDelegate?.animation(self, didDeselect: selectedNode)
        } else {
            node.isSelected = true
            animationDelegate?.animation(self, didSelect: node)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoving = false
    }
}

//
//  Animation.swift
//  CoCo
//
//  Created by 최영준 on 19/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import SpriteKit

/**
 PetKeywordViewController에서 사용되는 애니메이션 동작.
 
 AnimationNode를 생성한 후, addChild(_:) 또는 addChildPetNode(_:)에 추가하여 사용한다.
 ```
 func addChild(_ node: SKNode)
 func addChildPetNode(_ node: AnimationNode)
 ```
 
 터치 이벤트를 오버라이드하여서 노드의 이동 및 선택 동작을 즉시 반영하여 보여준다.
 
 - Author: [최영준](https://github.com/0jun0815)
 */
class Animation: SKScene {
    // MARK: - Properties
    /// true: 다중 선택 가능, false: 단일 선택만 가능
    var isMultipleTouchEnabled: Bool = true
    /// 선택된 노드 리스트(펫 노드는 제외)
    var selectedNodes: [AnimationNode] {
        return children.compactMap { $0 as? AnimationNode }.filter { $0.isSelected }.filter { !petNodes.contains($0) }
    }
    /// 펫 노드 리스트
    var petNodes = [AnimationNode]()
    /// AnimationType 델리게이트
    weak var animationDelegate: AnimationType?
    override var size: CGSize {
        didSet {
            setProperties()
        }
    }

    // MARK: - Private properties
    private var fieldNode: SKFieldNode?
    private var isMoving: Bool = false

    // MARK: - Initialiers
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

    // MARK: Set methods
    /// 속성들을 생성 및 수정한다.
    private func setProperties() {
        let strength = Float(max(size.width, size.height))
        let radius = strength.squareRoot() * 100
        updatePhycisBody(rect: self.frame, radius: CGFloat(radius))
        updateFieldNode(strength: strength, radius: radius)
    }
    /// physicsBody 생성 작업 수행
    private func updatePhycisBody(rect: CGRect, radius: CGFloat) {
        var rect = rect
        rect.size.width = radius
        rect.origin.x -= rect.size.width / 2
        physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
    }
    /// fieldNode 생성 작업 수행
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

    // MARK: - Add node methods
    override func addChild(_ node: SKNode) {
        // 상하 좌우 랜덤으로 등장
        let x = CGFloat.random(in: -node.frame.width ... frame.width + node.frame.width)
        let y = CGFloat.random(in: node.frame.height ... frame.height - node.frame.height)
        node.position = CGPoint(x: x, y: y)
        super.addChild(node)
    }
    /// 펫 노드 추가 메서드
    func addChildPetNode(_ node: AnimationNode) {
        petNodes.append(node)
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
        // 전체 노드들을 이동시킨다.
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
        if petNodes.contains(node) {
            for other in petNodes {
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
        } else if !isMultipleTouchEnabled, let selectedNode = selectedNodes.first {
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

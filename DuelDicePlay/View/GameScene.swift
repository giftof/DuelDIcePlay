//
//  GameScene.swift
//  DuelDicePlay
//
//  Created by kyuhkim on 2021/10/16.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let updateDelay = 0.3
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var spinnyNode : SKShapeNode?
    
    var dice1: SKLabelNode?
    var dice2: SKLabelNode?
    var label: SKLabelNode?
    // viewController 를 이렇게 받아도 되나?
    var viewController: GameViewController?

    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        setMyDice()
        setEnemyDice()
        setResultText()
        setParticle()
    }
    
    func setReference(by reference: GameViewController) {
        self.viewController = reference
    }
}


// MARK: - update(GameScene)

extension GameScene {
    
    
    func setMyDice() {
        self.dice1 = self.childNode(withName: "//dice1Label") as? SKLabelNode
        if let dice1 = self.dice1 {
            dice1.alpha = 0.0
            dice1.run(SKAction.fadeIn(withDuration: 2.0))
            dice1.text = "my dice"
        }
    }

    func setEnemyDice() {
        self.dice2 = self.childNode(withName: "//dice2Label") as? SKLabelNode
        if let dice2 = self.dice2 {
            dice2.alpha = 0.0
            dice2.run(SKAction.fadeIn(withDuration: 2.0))
            dice2.text = "enemy dice"
        }

    }

    func setResultText() {
        self.label = self.childNode(withName: "//rollResult") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
            label.text = "---"
        }
    }
    
    func setParticle() {
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
}


// MARK: - update(GameScene)

extension GameScene {
    
    override func update(_ currentTime: TimeInterval) {
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        let dt = currentTime - self.lastUpdateTime
        
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}


// MARK: - touchEven(GameScene)

extension GameScene {
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + updateDelay) {
                // 어찌 처리하는게 좋을지는 모르겠지만... 암튼, 이렇게 처리됨
                // controller의 모든 함수에 접근할수 있는것도 마음에 들지 않음.
                // 그렇다고, 함수포인터로 전달한들...
                // 당초에, controller를 이런식으로 전달하는게 맞는지가 의문임.
                self.viewController?.rollDice()
            }
        }

        if let dice1 = self.dice1 {
            dice1.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        if let dice2 = self.dice2 {
            dice2.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}






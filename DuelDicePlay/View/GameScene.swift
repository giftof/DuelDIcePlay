//
//  GameScene.swift
//  DuelDicePlay
//
//  Created by kyuhkim on 2021/10/16.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var user:       User?
    var network:    Network = Network()
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        
        
        /* test code start */
        user = createMyInstance()
        
        print(user!.instance!.diceUUIDArray.count)
        print(user!.dices[0].faceCount)
        print(user!.dices[1].faceCount)
        print(user!.dices[2].faceCount)
        

        
        
        
//        let dice = createDice()
//        let rawData = network.diceHistory(with: dice.uuid)
//        let decode:DiceHistoryModel = DecodeJson().with(rawData: rawData)
//        let pair = MakePair().with(arraySource: decode.nameHistory)
//        
//        for (left, right) in pair {
//            print(left, right)
//        }
        
        
        /* test code end */
    }
    
    
}

// MARK: - MyFunc(GameScene)

extension GameScene {
    
    func createMyInstance() -> User {
        let user = User()
        let instance:UserModel = DecodeJson().with(rawData: network.myData())
        
        user.instance = instance
        addDice(to: user)
        
        return user
    }

    
    
    func createUserInstanceByNameTag(name: String, tag: String) -> User {
        let someone = User()
        let instance:UserModel = DecodeJson().with(rawData: network.someoneData(name: name, tag: tag))
        
        someone.instance = instance
        addDice(to: someone)
        
        return someone
    }
    
    
    
    func createDice() -> DiceModel {
        let dice:DiceModel = DecodeJson().with(rawData: network.diceData())
        
        return dice
    }
    
    
    
    func addDice(to target: User) {
        var amount = 0
        while amount < target.instance?.diceUUIDArray.count ?? 0 {
            let dice = createDice()
            target.dices.append(dice)
            amount += 1
        }
    }
}




// MARK: - update(GameScene)

extension GameScene {
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
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

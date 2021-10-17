//
//  GameViewController.swift
//  DuelDicePlay
//
//  Created by kyuhkim on 2021/10/16.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var user:       User?
    var network:    Network = Network()

    var dice1: SKLabelNode?
    var dice2: SKLabelNode?
    var label: SKLabelNode?

    override func viewDidLoad() {
        print("viewController loaded super")
        super.viewDidLoad()
        print("viewController loaded start")
        if let scene = GKScene(fileNamed: "GameScene") {
            
            if let sceneNode = scene.rootNode as! GameScene? {
                
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                sceneNode.scaleMode = .aspectFill
                
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
                
                setDefaultData(sceneNode: sceneNode)
                sceneNode.setViewController(viewController: self)
            }
        }
        
        print("viewController loaded end")
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}


// MARK: - MyFunc(GameScene)

extension GameViewController {

    // 이부분을, 어떻게 연결하는게 좋은건지 모르겠음...
    func setDefaultData(sceneNode: GameScene) {
        user = createMyInstance()
        
        self.dice1 = sceneNode.dice1
        self.dice2 = sceneNode.dice2
        self.label = sceneNode.label
    }
    
    
    
    func rollDice() {
        let my = rollResult()
        let enemy = rollResult()
        let result = resultString(my: my, enemy: enemy)
        
        dice1?.text = "my roll = \(my)"
        dice2?.text = "enemy roll = \(enemy)"
        label?.text = result
        print(result)
    }
    
    
    
    func resultString(my: Int, enemy: Int) -> String {
        if (my < enemy) { return "LOSE!" }
        if (enemy < my) { return "WIN!" }
        return "TIE~~~"
    }
}

// MARK: - MyFunc(GameScene)

extension GameViewController {
    
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
    
    
    
//    func rollResult() {
//        let roll: DiceRoll = DecodeJson().with(rawData: network.diceRoll())
//        for element in roll.numbers {
//            print(element)
//        }
//    }



    func rollResult() -> Int {
        var sum = 0
        let roll: DiceRoll = DecodeJson().with(rawData: network.diceRoll())
        for element in roll.numbers {
            print(element)
            sum += element
        }
        return sum
    }
}

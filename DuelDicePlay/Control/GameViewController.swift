//
//  GameViewController.swift
//  DuelDicePlay
//
//  Created by kyuhkim on 2021/10/16.
//

import UIKit
import SpriteKit
import GameplayKit

class OBUser: User {
    
    @objc dynamic var observed = 0
    
    override var sumOfDiceResult:Int {
        didSet {
            observed = sumOfDiceResult
        }
    }
}

class GameViewController: UIViewController {
    var user        = OBUser()
    var enemy       = OBUser()
    var userObservation : NSKeyValueObservation?
    var enemyObservation: NSKeyValueObservation?
    var both        = RollingCountUserAndEnemy()
    var other:      [OBUser] = []
    
    let testCount = 4
    
    var dice1: SKLabelNode?
    var dice2: SKLabelNode?
    var label: SKLabelNode?

    override func viewDidLoad() {
        super.viewDidLoad()
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
                
                setObservation()
                user.createUserInstance()                               // 아직 필요 없음
                enemy.createUserInstanceBy(name: "noname", tag: "2022") // 아직 필요 없음
                // 아래 두줄처럼 전달하는게 MVC패턴에 맞나?
                getLabelNodeFrom(sceneNode: sceneNode)
                sceneNode.setReference(to: self)
            }
        }
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


// MARK: - MyFunc(Observe)

extension GameViewController {
    
    func setObservation() {
        userObservation = user.observe(\.observed, options: [.old, .new]) { (object, change) in
            self.dice1?.text = "my roll = \(change.newValue!)"
            self.both.user += 1
            self.DidBothOfYouRollTheDice()
        }
        enemyObservation = enemy.observe(\.observed, options: [.old, .new]) { (object, change) in
            self.dice2?.text = "enemy roll = \(change.newValue!)"
            self.both.enemy += 1
            self.DidBothOfYouRollTheDice()
        }
    }
}


// MARK: - MyFunc(GameScene)

extension GameViewController {
    
    func DidBothOfYouRollTheDice() {
        if ((self.both.enemy >= testCount) && (self.both.user >= testCount)) {
            self.both.enemy = 0
            self.both.user  = 0
            self.label?.text = resultString(my: user.sumOfDiceResult, enemy: enemy.sumOfDiceResult)
        }
    }

    // 이부분을, 어떻게 연결하는게 좋은건지 모르겠음... (이래도 되나?)
    func getLabelNodeFrom(sceneNode: GameScene) {
        self.dice1 = sceneNode.dice1
        self.dice2 = sceneNode.dice2
        self.label = sceneNode.label
    }
    
    func doRolling() {
        user.requestRollingDices()
        enemy.requestRollingDices()
    }
    
    func resultString(my: Int, enemy: Int) -> String {
        if (my < enemy) { return "Defeated!" }
        if (enemy < my) { return "WIN!" }
        return "~~~Draw~~~"
    }
}


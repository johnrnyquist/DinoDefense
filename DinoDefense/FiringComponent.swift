//
//  FiringComponent.swift
//  DinoDefense
//
//  Created by Toby Stephens on 20/10/2015.
//  Copyright © 2015 razeware. All rights reserved.
//

import SpriteKit
import GameplayKit

class FiringComponent: GKComponent {
    let towerType: TowerType
    let parentNode: SKNode
    var currentTarget: DinosaurEntity?
    var timeTillNextShot: TimeInterval = 0

    init(towerType: TowerType,
         parentNode: SKNode) {
        self.towerType = towerType
        self.parentNode = parentNode
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)

        guard let target = currentTarget else { return }

        timeTillNextShot -= seconds
        if timeTillNextShot > 0 { return }
        timeTillNextShot = towerType.fireRate

        // 1
        let projectile = ProjectileEntity(towerType: towerType)
        let projectileNode = projectile.spriteComponent.node
        projectileNode.position = CGPoint(x: 0.0,
                                          y: 50.0)
        parentNode.addChild(projectileNode)

        // 2
        let targetNode = target.spriteComponent.node
        projectileNode.rotateToFaceNode(targetNode: targetNode,
                                        sourceNode: parentNode)

        // 3
        let fireVector = CGVector(dx: targetNode.position.x - parentNode.position.x,
                                  dy: targetNode.position.y - parentNode.position.y)

        // 4
        let soundAction = SKAction.playSoundFileNamed("\(towerType.rawValue)Fire.mp3",
                                                      waitForCompletion: false)
        let fireAction = SKAction.move(by: fireVector,
                                       duration: 0.4)
        let damageAction = SKAction.run { () -> Void in
            target.healthComponent.takeDamage(damage: self.towerType.damage)
            if self.towerType.hasSlowingEffect {
                target.slowed(slowFactor: self.towerType.slowFactor)
            }
        }
        let removeAction = SKAction.run { () -> Void in
            projectileNode.removeFromParent()
        }
        let action = SKAction.sequence([soundAction, fireAction, damageAction, removeAction])
        projectileNode.run(action)
    }
}



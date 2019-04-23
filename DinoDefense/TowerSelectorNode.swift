//
//  TowerSelectorNode.swift
//  DinoDefense
//
//  Created by Toby Stephens on 21/10/2015.
//  Copyright © 2015 razeware. All rights reserved.
//

import SpriteKit

class TowerSelectorNode: SKNode {
  
  var showAction = SKAction()
  var hideAction = SKAction()
  
  var costLabel: SKLabelNode {
    return self.childNode(withName: "CostLabel") as! SKLabelNode
  }
  
  var towerIcon: SKSpriteNode {
    return self.childNode(withName: "TowerIcon") as! SKSpriteNode
  }
  
  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setTower(towerType: TowerType, angle: CGFloat) {
    // Set the name and icon
    towerIcon.texture = SKTexture(imageNamed: towerType.rawValue)
    towerIcon.name = "Tower_Icon_\(towerType.rawValue)"
    
    // Set the cost
    costLabel.text = "\(towerType.cost)"
    
    self.zRotation = 180.degreesToRadians()
    
    let rotateAction = SKAction.rotate(
        byAngle: 180.degreesToRadians(),
      duration: 0.2)
    
    let moveAction = SKAction.moveBy(
        x: cos(angle) * 50,
      y: sin(angle) * 50,
      duration: 0.2)
    
    showAction = SKAction.group([rotateAction, moveAction])
    hideAction = showAction.reversed()
  }
  
  func show() {
    self.run(showAction)
  }
  
    func hide(completion: @escaping () -> ()) {
    self.run(SKAction.sequence([
      hideAction, SKAction.run(completion)]))
  }
  
}


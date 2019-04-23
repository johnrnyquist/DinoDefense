//
//  ShadowComponent.swift
//  DinoDefense
//
//  Created by Toby Stephens on 20/10/2015.
//  Copyright © 2015 razeware. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class ShadowComponent: GKComponent {
  
  let node: SKShapeNode
  
  let size: CGSize
  
  init(size: CGSize, offset: CGPoint) {
    self.size = size
    
    node = SKShapeNode(ellipseOf: size)
    node.fillColor = SKColor.black
    node.strokeColor = SKColor.black
    node.alpha = 0.2
    node.position = offset
    super.init()
  }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  func createObstaclesAtPosition(position: CGPoint) -> [GKPolygonObstacle] {
    let centerX = position.x + node.position.x
    let centerY = position.y + node.position.y
    let left = float2(CGPoint(x: centerX - size.width/2, y:  centerY))
    let top = float2(CGPoint(x: centerX, y:  centerY + size.height/2))
    let right = float2(CGPoint(x: centerX + size.width/2, y:  centerY))
    let bottom = float2(CGPoint(x: centerX, y:  centerY - size.height/2))
    var vertices = [left, bottom, right, top]
    
    let obstacle = GKPolygonObstacle(__points: &vertices, count: 4)
    return [obstacle]
  }
  
}


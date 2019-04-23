//
//  ObstacleEntity.swift
//  DinoDefense
//
//  Created by Toby Stephens on 21/10/2015.
//  Copyright © 2015 razeware. All rights reserved.
//

import SpriteKit
import GameplayKit

class ObstacleEntity: GKEntity {
    // 1
    var spriteComponent: SpriteComponent!
    // 2
    var shadowComponent: ShadowComponent!

    // 3
    init(withNode node: SKSpriteNode) {
        super.init()

        // 4
        spriteComponent = SpriteComponent(entity: self,
                                          texture: node.texture!,
                                          size: node.size)
        addComponent(spriteComponent)

        // 5
        let shadowSize = CGSize(width: node.size.width * 1.1,
                                height: node.size.height * 0.6)
        shadowComponent = ShadowComponent(size: shadowSize,
                                          offset: CGPoint(x: 0.0,
                                                          y: -node.size.height * 0.35))
        addComponent(shadowComponent)

        // 6
        spriteComponent.node.position = node.position
        node.position = CGPoint.zero
        spriteComponent.node.addChild(node)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



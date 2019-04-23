//
//  SpriteComponent.swift
//  DinoDefense
//
//  Created by Toby Stephens on 20/10/2015.
//  Copyright © 2015 razeware. All rights reserved.
//

import SpriteKit
import GameplayKit

class EntityNode: SKSpriteNode {
    weak var ent: GKEntity!
}

class SpriteComponent: GKComponent {
    // A node that gives an entity a visual sprite
    let node: EntityNode

    init(entity: GKEntity,
         texture: SKTexture,
         size: CGSize) {
        node = EntityNode(texture: texture,
                          color: SKColor.white,
                          size: size)
        node.ent = entity
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


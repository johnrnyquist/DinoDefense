//
//  TowerEntity.swift
//  DinoDefense
//
//  Created by Toby Stephens on 20/10/2015.
//  Copyright © 2015 razeware. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

enum TowerType: String {
    case Wood = "WoodTower"
    case Rock = "RockTower"
    static let allValues = [Wood, Rock]
    var fireRate: Double {
        switch self {
            case .Wood: return 1.0
            case .Rock: return 1.5
        }
    }
    var damage: Int {
        switch self {
            case .Wood: return 20
            case .Rock: return 50
        }
    }
    var range: CGFloat {
        switch self {
            case .Wood: return 200
            case .Rock: return 250
        }
    }
    var cost: Int {
        switch self {
            case .Wood: return 50
            case .Rock: return 85
        }
    }
    var slowFactor: Float {
        switch self {
            case .Wood: return 1
            case .Rock: return 0.5
        }
    }
    var hasSlowingEffect: Bool {
        return slowFactor < 1.0
    }
}

class TowerEntity: GKEntity {
    let towerType: TowerType
    var spriteComponent: SpriteComponent!
    var shadowComponent: ShadowComponent!
    var animationComponent: AnimationComponent!
    var firingComponent: FiringComponent!

    init(towerType: TowerType) {
        // Store the TowerType
        self.towerType = towerType
        super.init()
        let textureAtlas = SKTextureAtlas(named: towerType.rawValue)
        let defaultTexture = textureAtlas.textureNamed("Idle__000")
        let textureSize = CGSize(width: 98,
                                 height: 140)
        // Add the SpriteComponent
        spriteComponent = SpriteComponent(entity: self,
                                          texture: defaultTexture,
                                          size: textureSize)
        addComponent(spriteComponent)
        // Add the ShadowComponent
        let shadowSize = CGSize(width: 98,
                                height: 44)
        shadowComponent = ShadowComponent(size: shadowSize,
                                          offset: CGPoint(x: 0.0,
                                                          y: -textureSize.height / 2 + shadowSize.height / 2))
        addComponent(shadowComponent)
        // Add the AnimationComponent
        animationComponent = AnimationComponent(node: spriteComponent.node,
                                                textureSize: textureSize,
                                                animations: loadAnimations())
        addComponent(animationComponent)
        firingComponent = FiringComponent(towerType: towerType,
                                          parentNode: spriteComponent.node)
        addComponent(firingComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadAnimations() -> [AnimationState: Animation] {
        let textureAtlas = SKTextureAtlas(named: towerType.rawValue)
        var animations = [AnimationState: Animation]()
        animations[.Idle] = AnimationComponent.animationFromAtlas(atlas: textureAtlas,
                                                                  withImageIdentifier: "Idle",
                                                                  forAnimationState: .Idle)
        animations[.Attacking] = AnimationComponent.animationFromAtlas(atlas: textureAtlas,
                                                                       withImageIdentifier: "Attacking",
                                                                       forAnimationState: .Attacking)
        return animations
    }
}




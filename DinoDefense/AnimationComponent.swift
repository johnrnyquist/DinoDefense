//
//  AnimationComponent.swift
//  DinoDefense
//
//  Created by Toby Stephens on 20/10/2015.
//  Copyright © 2015 razeware. All rights reserved.
//

import SpriteKit
import GameplayKit

enum AnimationState: String {
    case Idle = "Idle"
    case Walk = "Walk"
    case Hit = "Hit"
    case Dead = "Dead"
    case Attacking = "Attacking"
}

struct Animation {
    let animationState: AnimationState
    let textures: [SKTexture]
    let repeatTexturesForever: Bool
}

class AnimationComponent: GKComponent {
    // 1
    let node: SKSpriteNode
    // 2
    var animations: [AnimationState: Animation]
    // 3
    private(set) var currentAnimation: Animation?
    var requestedAnimationState: AnimationState?

    // 4
    init(node: SKSpriteNode,
         textureSize: CGSize,
         animations: [AnimationState: Animation]) {

        self.node = node
        self.animations = animations
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)

        if let animationState = requestedAnimationState {
            runAnimationForAnimationState(animationState: animationState)
            requestedAnimationState = nil
        }
    }

    class func animationFromAtlas(atlas: SKTextureAtlas,
                                  withImageIdentifier identifier: String,
                                  forAnimationState animationState: AnimationState,
                                  repeatTexturesForever: Bool = true) -> Animation {

        let textures = atlas.textureNames.filter { $0.hasPrefix("\(identifier)_") }.sorted { $0 < $1 }.map { atlas.textureNamed($0) }

        return Animation(animationState: animationState,
                         textures: textures,
                         repeatTexturesForever: repeatTexturesForever)
    }

    private func runAnimationForAnimationState(animationState: AnimationState) {

        // 1
        let actionKey = "Animation"
        // 2
        let timePerFrame = TimeInterval(1.0 / 30.0)

        // 3
        if currentAnimation != nil && currentAnimation!.animationState == animationState { return }

        // 4
        guard let animation = animations[
            animationState
            ] else {
            print("Unknown animation for state \(animationState.rawValue)")
            return
        }

        // 5
        node.removeAction(forKey: actionKey)

        // 6
        let texturesAction: SKAction
        if animation.repeatTexturesForever {
            texturesAction = SKAction.repeatForever(SKAction.animate(with: animation.textures,
                                                                     timePerFrame: timePerFrame))
        } else {
            texturesAction = SKAction.animate(with: animation.textures,
                                              timePerFrame: timePerFrame)
        }

        // 7
        node.run(texturesAction,
                 withKey: actionKey)

        // 8
        currentAnimation = animation
    }
}



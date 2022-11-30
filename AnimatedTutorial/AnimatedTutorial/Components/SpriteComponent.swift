//
//  SpriteComponent.swift
//  AnimatedTutorial
//
//  Created by zy on 30/11/22.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    // A node that gives an entity a visual sprite
    let node: SKSpriteNode

    init(entity: GKEntity, texture: SKTexture, size: CGSize) {
        node = SKSpriteNode(texture: texture, color: SKColor.white, size: size)
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//
//  GameScene.swift
//  AnimatedTutorial
//
//  Created by zy on 30/11/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let background = SKSpriteNode(imageNamed: "background")
    var character: Character?

    // Entity-component system
    var entityManager: EntityManager!

    override func sceneDidLoad() {
        // Create entity manager
        entityManager = EntityManager(scene: self)

        // Add background
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: size.width, height: size.height)
        background.zPosition = -1
        addChild(background)

        // Add animated character
        character = Character(imageName: "LionStoryAnimation")
        if let spriteComponent = character?.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: 0, y: -80)
            spriteComponent.node.zPosition = 10
        }

        if let character = character {
            entityManager.add(character)
        }
    }
}

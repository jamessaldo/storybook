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
    var character = SKSpriteNode()

    override func sceneDidLoad() {
        // Add background
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSize(width: size.width, height: size.height)
        background.zPosition = -1
        addChild(background)

        // Add animated character
        var characterAtlas: SKTextureAtlas {
            return SKTextureAtlas(named: "LionStoryAnimation")
        }

        var characterTexture: SKTexture {
            return characterAtlas.textureNamed("LionStoryAnimation")
        }

        var characterIdleTexture: [SKTexture] {

            var index: [SKTexture] = []
            let imagesName = characterAtlas.textureNames

            for name in imagesName {
                let textureNames = characterAtlas.textureNamed(name)
                index.append(textureNames)
            }
            return index

        }
        character = SKSpriteNode(texture: characterTexture)
        character.zPosition = 10
        character.position = CGPoint(x: 0, y: -80)
        let idleAnimation = SKAction.animate(with: characterIdleTexture, timePerFrame: 0.2)
        character.run(SKAction.repeatForever(idleAnimation), withKey: "chracterIdleAnimation")
        addChild(character)
    }
}

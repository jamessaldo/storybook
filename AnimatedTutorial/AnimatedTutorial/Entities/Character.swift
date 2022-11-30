//
//  Character.swift
//  AnimatedTutorial
//
//  Created by zy on 30/11/22.
//

import SpriteKit
import GameplayKit

class Character: GKEntity {

    init(imageName: String) {
        super.init()

        var characterAtlas: SKTextureAtlas {
            return SKTextureAtlas(named: imageName)
        }

        var characterTexture: SKTexture {
            return characterAtlas.textureNamed(imageName)
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

        let spriteComponent = SpriteComponent(
            entity: self,
            texture: characterTexture,
            size: characterTexture.size()
        )
        addComponent(spriteComponent)

        let idleAnimation = SKAction.animate(with: characterIdleTexture, timePerFrame: 0.2)
        spriteComponent.node.run(SKAction.repeatForever(idleAnimation), withKey: "chracterIdleAnimation")

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

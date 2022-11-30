//
//  EntityManager.swift
//  AnimatedTutorial
//
//  Created by zy on 30/11/22.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {

    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    let scene: SKScene

    init(scene: SKScene) {
        self.scene = scene
    }

    func add(_ entity: GKEntity) {
        entities.insert(entity)

        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }

    }

    func remove(_ entity: GKEntity) {

        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }

        toRemove.insert(entity)
        entities.remove(entity)
    }

    func update(_ deltaTime: CFTimeInterval) {
        toRemove.removeAll()
    }
}

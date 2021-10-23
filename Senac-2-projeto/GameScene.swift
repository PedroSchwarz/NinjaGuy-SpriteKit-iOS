//
//  GameScene.swift
//  Senac-2-projeto
//
//  Created by Pedro Rodrigues on 23/10/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // NinjaGuy sprite
    var ninjaGuy: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        // Set screen render to center
        self.anchorPoint = .init(x: 0.5, y: 0.5)
        // Get NinjaGuy image from assets
        self.ninjaGuy = SKSpriteNode(imageNamed: "ninja")
        // Check is not nil and add to scene
        if let ninja = self.ninjaGuy {
            addChild(ninja)
        }
        // Create limits (Dojo)
        let celling = SKSpriteNode(color: .brown, size: CGSize(width: 1000, height: 10))
        let floor = SKSpriteNode(color: .brown, size: CGSize(width: 1000, height: 10))
        let rWall = SKSpriteNode(color: .brown, size: CGSize(width: 10, height: 1000))
        let lWall = SKSpriteNode(color: .brown, size: CGSize(width: 10, height: 1000))
        // Add to an array
        let objects = [celling, floor, rWall, lWall]
        // Set sprites positions to mimic a dojo
        celling.position.y = self.size.height / 2
        floor.position.y = -self.size.height / 2
        rWall.position.x = -self.size.width / 2
        lWall.position.x = self.size.width / 2
        // For each sprite apply physics an add to scene
        objects.forEach {
            self.applyPhysics(object: $0)
            self.addChild($0)
        }
        // Code from Aula 2
        
        //        let node = SKSpriteNode(color: .blue, size: CGSize(width: 100, height: 100))
        
        //        let physicsNode = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
        
        //        let floor = SKSpriteNode(color: .green, size: CGSize(width: 2000, height: 10))
        //
        //        let moveUp = SKAction.moveBy(x: 0, y: 300, duration: 3)
        //        let moveDown = SKAction.moveBy(x: 0, y: -300, duration: 3)
        //        let fadeOut = SKAction.fadeOut(withDuration: 3)
        //        let fadeIn = SKAction.fadeIn(withDuration: 3)
        //
        //        let moveDownAndFadeOut = SKAction.group([moveDown, fadeOut])
        //        let moveUpAndFadeIn = SKAction.group([moveUp, fadeIn])
        //
        //        let sequence = SKAction.sequence([moveUp, moveDownAndFadeOut, moveDown, moveUpAndFadeIn])
        //
        //        node.run(SKAction.repeatForever(sequence))
        //
        //        let action = SKAction.repeatForever(SKAction.move(by: CGVector(dx: 0, dy: 10), duration: 1))
        //        let rotation = SKAction.repeatForever(SKAction.rotate(byAngle: 10, duration: 1))
        
        //        node.run(action)
        //        node.run(rotation)
        
        //        let sprite = SKSpriteNode(imageNamed: "coffee")
        //
        //        sprite.run(action)
        //        sprite.run(rotation)
        //
        //        physicsNode.physicsBody = SKPhysicsBody(rectangleOf: physicsNode.size)
        //        physicsNode.run(SKAction.wait(forDuration: 3)) {
        //            physicsNode.physicsBody?.applyImpulse(CGVector(dx: 2, dy: 500))
        //        }
        //        physicsNode.physicsBody?.restitution = 0.5
        //        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        //        floor.physicsBody?.isDynamic = false
        //        floor.position.y = -self.size.height / 2
        
        //        addChild(node)
        //        addChild(sprite)
        //        addChild(physicsNode)
        //        addChild(floor)
    }
    // Method to apply physics
    func applyPhysics(object: SKSpriteNode) {
        object.physicsBody = SKPhysicsBody(rectangleOf: object.size)
        object.physicsBody?.isDynamic = false
        // After a quick search, category is necessary for collision with shurikens
        object.physicsBody?.categoryBitMask = 0b0001
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if pos != self.ninjaGuy?.position {
            // Set new position to ninja
            self.ninjaGuy?.position = pos
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if pos != self.ninjaGuy?.position {
            // Set new position to ninja
            self.ninjaGuy?.position = pos
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        // If the clicked position is the current one
        if pos == self.ninjaGuy?.position {
            // Create a shuriken sprite (Couldn`t find a nice image for that)
            let shuriken = SKSpriteNode(color: .gray, size: CGSize(width: 20, height: 20))
            // Set position to current (Same as ninja)
            shuriken.position = pos
            // Apply physics
            shuriken.physicsBody = SKPhysicsBody(rectangleOf: shuriken.size)
            // Set collision to the same as the walls
            shuriken.physicsBody?.collisionBitMask = 0b0001
            // Apply a impulse to send shuriken flying
            shuriken.run(SKAction.wait(forDuration: 0.2)) {
                shuriken.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            }
            // Make it rotate for cool effect
            shuriken.run(SKAction.repeatForever(SKAction.rotate(byAngle: 10, duration: 2)))
            // Add to scene
            self.addChild(shuriken)
            // After 3 secs, fade and remove shuriken
            shuriken.run(SKAction.sequence([SKAction.wait(forDuration: 3),
                                              SKAction.fadeOut(withDuration: 3),
                                              SKAction.removeFromParent()]))
            return
        }
        // Set new position to ninja
        self.ninjaGuy?.position = pos
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}

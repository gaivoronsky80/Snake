//
//  GameScene.swift
//  Snake
//
//  Created by Web Developer on 7/13/19.
//  Copyright © 2019 Web Developer. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player = SKShapeNode()
    var mang: [SKShapeNode] = []
    var food = SKShapeNode()
    
    //
    struct vatthe {
        static let player: UInt32 = 0x1 << 1
        static let food: UInt32 = 0x1 << 2
    }
    
    override func didMove(to view: SKView) {
        //
        self.physicsWorld.contactDelegate = self
        create_snake()
        create_food()
    }
    
    //
    func create_snake() {
        var count = 0
        var y: CGFloat = 5
        while count < 5 {
            count = count + 1
            let snake = SKShapeNode(circleOfRadius: 25)
            snake.fillColor = UIColor.red
            snake.strokeColor = UIColor.red
            snake.position = CGPoint(x: 0, y: y - snake.frame.size.height)
            y = y - 50
            addChild(snake)
            mang.append(snake)
        }
        
        //
        for i in 1...mang.count - 1 {
            let nodeA = mang[i - 1]
            let nodeB = mang[i]
            let rangetoNode = SKRange(lowerLimit: 50, upperLimit: 50)
            let distanceContraint = SKConstraint.distance(rangetoNode, to: nodeA)
            let rangeforOrientation = SKRange(lowerLimit: CGFloat(Double.pi/2), upperLimit: CGFloat(Double.pi/2))
            let OrientContrains = SKConstraint.orient(to: nodeA, offset: rangeforOrientation)
            nodeB.constraints = [distanceContraint, OrientContrains]
        }
        mang[0].physicsBody = SKPhysicsBody(circleOfRadius: 25)
        mang[0].physicsBody?.isDynamic = true
        mang[0].physicsBody?.affectedByGravity = false
        mang[0].physicsBody?.categoryBitMask = vatthe.player
        mang[0].physicsBody?.contactTestBitMask = vatthe.food
    }
    
    //
    func create_food() {
        food = SKShapeNode(circleOfRadius: 25)
        food.fillColor = UIColor.red
        food.position = CGPoint(x: randomCGFloat(min: -self.size.width/2 + 100, max: self.size.width/2 - 200), y: randomCGFloat(min: -self.size.height/2 + 200, max: self.size.height/2 - 200))
        food.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        food.physicsBody?.isDynamic = true
        food.physicsBody?.affectedByGravity = false
        food.physicsBody?.categoryBitMask = vatthe.food
        food.physicsBody?.contactTestBitMask = vatthe.player
        addChild(food)
    }
    
    //
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        if body1.categoryBitMask > body2.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if contact.bodyA.categoryBitMask == vatthe.player && contact.bodyB.categoryBitMask == vatthe.food {
            print("ran da an moi")
            food.removeFromParent()
            create_food()
            create_addNode()
        }
    }
    
    //
    func create_addNode() {
        //
        let food1 = SKShapeNode(circleOfRadius: 25)
        food1.fillColor = UIColor(displayP3Red: randomCGFloat(min: randomCGFloat(min: 0.1, max: 1), max: randomCGFloat(min: 0.1, max: 1)), green: randomCGFloat(min: 0.1, max: 1), blue: randomCGFloat(min: 0.1, max: 1), alpha: 1)
        food1.strokeColor = UIColor.red
        mang.append(food1)
        mang[mang.count - 1].position = CGPoint(x: mang[mang.count - 2].position.x, y: mang[mang.count - 2].position.y - mang[mang.count - 2].frame.size.height)
        addChild(mang[mang.count - 1])
        
        //
        let rangetoNode = SKRange(lowerLimit: 50, upperLimit: 50)
        let distanceContraint = SKConstraint.distance(rangetoNode, to: mang[mang.count - 2])
        let rangeforOrientation = SKRange(lowerLimit: CGFloat(Double.pi/2), upperLimit: CGFloat(Double.pi/2))
        let OrientContrains = SKConstraint.orient(to: mang[mang.count - 2], offset: rangeforOrientation)
        mang[mang.count - 1].constraints = [distanceContraint, OrientContrains]
    }
    
    //
    func randomCGFloat(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random())/Float(UINT32_MAX))*(max - min) + min
    }
    
    //
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if self.contains(location) {
                mang[0].run(SKAction.move(to: location, duration: 0.5))
            }
        }
    }
}

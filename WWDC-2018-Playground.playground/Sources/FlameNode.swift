//
//  FlameNode.swift
//  helperForCarGame
//
//  Created by Aryeh Greenberg on 3/20/18.
//  Copyright © 2018 Aryeh Greenberg. All rights reserved.
//

import UIKit
import SpriteKit

public class FlameNode: SKSpriteNode {
    var soundNode:SKAudioNode!
    public init() {
        let texture = SKTexture(imageNamed: "flameOne")
        
        super.init(texture: texture,color:UIColor.clear, size: CGSize(width: 81, height: 182))
    
        
        
        self.zPosition = 0.9
        //self.zRotation = 3.14159
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 81, height: 182))
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.mass = 10
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.categoryBitMask = 0
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 0
    
        
        
        
    }
 
    public func turnOffThrusters() {
        
        soundNode.run(SKAction.stop())
        //soundNode.removeAllActions()
        //self.removeAllActions()
        soundNode.removeFromParent()
        self.removeFromParent()

    }
    
    
    public func turnOnThrusters() {
        let otherTexture = SKTexture(imageNamed: "flameTwo")
        let texture = SKTexture(imageNamed: "flameOne")
        
        let action = SKAction.repeatForever(SKAction.animate(with: [texture,otherTexture], timePerFrame: 0.2))
        self.run(action)
        //self.run(SKAction.applyForce(CGVector(dx:0,dy:-100000), duration: 40))
        
        if let acclURL = Bundle.main.url(forResource: "rocketSound", withExtension: "mp3") {
            soundNode = SKAudioNode(url: acclURL)
            soundNode.autoplayLooped = true
            self.addChild(soundNode)
            soundNode.run(SKAction.play())
            soundNode.isPositional = true
            
        }

    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

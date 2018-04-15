//
//  AppleCarWithWheels.swift
//  helperForCarGame
//
//  Created by Aryeh Greenberg on 3/20/18.
//  Copyright © 2018 Aryeh Greenberg. All rights reserved.
//

import UIKit
import SpriteKit

public class AppleCarWithWheels: SKNode {
    
    public var carNode:SKSpriteNode!
    private var headNode:SKSpriteNode!
    private var acclAudioNode:SKAudioNode?
    private var brakeAudioNode:SKAudioNode?
    public var wheelNodeLeft:SKSpriteNode!
    public var wheelNodeRight:SKSpriteNode!
    private var rightWheelAxel:SKSpriteNode!
    public var leftWheelAxel:SKSpriteNode!
    private var thruster:FlameNode!
    private var attachment:SKPhysicsJoint!
    
    
    public init(scene:SKScene,withTim:Bool) {
        super.init()
        
        
        let texture = SKTexture(imageNamed: "appleCarWithoutWheels")
        let size = CGSize(width: 331, height: 76)
        carNode = SKSpriteNode.init(texture: texture, size: size)
        carNode.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.2, size: size)
        carNode.physicsBody?.isDynamic = true
        //carNode.physicsBody?.mass = 100
        carNode.position = CGPoint(x: 0, y: 0)
        carNode.zPosition = 1
        carNode.physicsBody?.categoryBitMask = BitMasks.carMask
        carNode.physicsBody?.contactTestBitMask = BitMasks.finishFlagMask
        carNode.physicsBody?.collisionBitMask = BitMasks.floorMask
        carNode.physicsBody?.mass = 100
        carNode.physicsBody?.restitution = 0.0
        //carNode.physicsBody?.pinned = true
        //carNode.physicsBody?.allowsRotation = false
        
        
        self.addChild(carNode)
        
        let wheelNodeTexture = SKTexture(imageNamed: "appleCarWheel")
        let wheelSize = CGSize(width: 56, height: 56)
        wheelNodeLeft = SKSpriteNode(texture: wheelNodeTexture, size: wheelSize)
        wheelNodeLeft.physicsBody = SKPhysicsBody(circleOfRadius: 28)
        wheelNodeLeft.zPosition = 2
        wheelNodeLeft.physicsBody?.isDynamic = true
        wheelNodeLeft.physicsBody?.categoryBitMask = BitMasks.carMask
        wheelNodeLeft.physicsBody?.contactTestBitMask = BitMasks.finishFlagMask
        wheelNodeLeft.physicsBody?.collisionBitMask = BitMasks.floorMask
        wheelNodeLeft.position  = CGPoint(x: -120, y: -36)
        wheelNodeLeft.physicsBody?.friction = 0.6
        wheelNodeLeft.physicsBody?.restitution = 0.0
        //wheelNodeLeft.physicsBody?.pinned = true
        
        self.addChild(wheelNodeLeft)
        
        wheelNodeRight = wheelNodeLeft.copy() as! SKSpriteNode
        wheelNodeRight.position = CGPoint(x: 121, y: -36)
        
        self.addChild(wheelNodeRight)
       
        
        
        
        //self.physicsBody = SKPhysicsBody(bodies: [carNode.physicsBody!,headNode.physicsBody!])
        
        scene.addChild(self)
        addedToParent(withTim:withTim)
    }
    
    
    public init(scene:SKScene) {
        //let texture = SKTexture(imageNamed: "ball")
        super.init()
        
        
        let texture = SKTexture(imageNamed: "appleCarWithoutWheels")
        let size = CGSize(width: 331, height: 76)
        carNode = SKSpriteNode.init(texture: texture, size: size)
        carNode.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.2, size: size)
        carNode.physicsBody?.isDynamic = true
        //carNode.physicsBody?.mass = 100
        carNode.position = CGPoint(x: 0, y: 0)
        carNode.zPosition = 1
        carNode.physicsBody?.categoryBitMask = BitMasks.carMask
        carNode.physicsBody?.contactTestBitMask = BitMasks.finishFlagMask
        carNode.physicsBody?.collisionBitMask = BitMasks.floorMask
        carNode.physicsBody?.mass = 100
        carNode.physicsBody?.restitution = 0.0
        //carNode.physicsBody?.pinned = true
        //carNode.physicsBody?.allowsRotation = false
        
        
        self.addChild(carNode)
        
        let wheelNodeTexture = SKTexture(imageNamed: "appleCarWheel")
        let wheelSize = CGSize(width: 56, height: 56)
        wheelNodeLeft = SKSpriteNode(texture: wheelNodeTexture, size: wheelSize)
        wheelNodeLeft.physicsBody = SKPhysicsBody(circleOfRadius: 28)
        wheelNodeLeft.zPosition = 2
        wheelNodeLeft.physicsBody?.isDynamic = true
        wheelNodeLeft.physicsBody?.categoryBitMask = BitMasks.carMask
        wheelNodeLeft.physicsBody?.contactTestBitMask = BitMasks.finishFlagMask
        wheelNodeLeft.physicsBody?.collisionBitMask = BitMasks.floorMask
        wheelNodeLeft.position  = CGPoint(x: -120, y: -36)
        wheelNodeLeft.physicsBody?.friction = 0.6
        wheelNodeLeft.physicsBody?.restitution = 0.0
        //wheelNodeLeft.physicsBody?.pinned = true
        
        self.addChild(wheelNodeLeft)
        
        wheelNodeRight = wheelNodeLeft.copy() as! SKSpriteNode
        wheelNodeRight.position = CGPoint(x: 121, y: -36)
        
        self.addChild(wheelNodeRight)
        
        headNode = SKSpriteNode(imageNamed: "timmy")
        
        headNode.size = CGSize(width: carNode.size.width/6.6868, height: carNode.size.height * 0.9736)
        headNode.position = CGPoint(x:carNode.position.x + carNode.frame.size.width/8, y: carNode.frame.maxY + headNode.size.height/2 - 10)
        let texture2 = SKTexture(imageNamed: "timmy")
        headNode.physicsBody = SKPhysicsBody(texture: texture2, alphaThreshold: 0.2, size: headNode.size)
        headNode.physicsBody?.affectedByGravity = false
        headNode.physicsBody?.mass = carNode.physicsBody!.mass/20
        headNode.physicsBody?.categoryBitMask = BitMasks.headMask
        headNode.physicsBody?.collisionBitMask = BitMasks.floorMask
        headNode.physicsBody?.contactTestBitMask = 0
        headNode.zPosition = 0
        headNode.physicsBody?.allowsRotation = true
        
        
        //headNode.physicsBody.f
        
        self.addChild(headNode)
        
        
        
        
        //self.physicsBody = SKPhysicsBody(bodies: [carNode.physicsBody!,headNode.physicsBody!])
        
        scene.addChild(self)
        addedToParent(withTim:true)
        
        
    }
    
    public func flip() {
        carNode.position.y += 100
        headNode.zRotation += CGFloat.pi
        carNode.zRotation += CGFloat.pi
    }
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func startAccelerating() {
        if let acclURL = Bundle.main.url(forResource: "Acceleration", withExtension: "mp3") {
            if acclAudioNode == nil {
                acclAudioNode = SKAudioNode(url: acclURL)
                acclAudioNode!.autoplayLooped = true
                acclAudioNode?.isPositional = true
                self.addChild(acclAudioNode!)
            }
            
        }
        acclAudioNode?.position = CGPoint(x: 0, y: 0)
        acclAudioNode!.run(SKAction.play())
        
        
    }
    public func stopAccelerating() {
        let actionSequence = SKAction.sequence([SKAction.moveBy(x: 100000, y: 0, duration: 0.4),SKAction.stop()])
        acclAudioNode?.run(actionSequence)
    }
    public func startBraking() {
        if let brakeURL = Bundle.main.url(forResource: "brakingAudio", withExtension: "mp3") {
            if brakeAudioNode == nil {
                brakeAudioNode = SKAudioNode(url: brakeURL)
                brakeAudioNode!.autoplayLooped = true
                brakeAudioNode?.isPositional = true
                self.addChild(brakeAudioNode!)
            }
            
        }
        brakeAudioNode?.position = CGPoint(x: 0, y: 0)
        brakeAudioNode!.run(SKAction.play())
    }
    
    public func stopBraking() {
        let actionSequence = SKAction.stop()
        brakeAudioNode?.run(actionSequence)
    }
    
    
    public func addedToParent(withTim:Bool) {
        
        if withTim {
        let pin = SKPhysicsJointPin.joint(withBodyA: carNode.physicsBody!, bodyB: headNode.physicsBody!, anchor: CGPoint(x: headNode.frame.minX, y: headNode.frame.minY))
        pin.lowerAngleLimit = 0.0
        pin.upperAngleLimit = 0.6
        //pin.rotationSpeed = 6.0
        pin.shouldEnableLimits = true
        pin.frictionTorque = 1.0
        
        
        
        
        let springJoint = SKPhysicsJointSpring.joint(withBodyA: carNode.physicsBody!, bodyB: headNode.physicsBody!, anchorA: CGPoint(x: headNode.frame.maxX, y: headNode.frame.minY), anchorB: CGPoint(x: headNode.frame.maxX, y: headNode.frame.minY))
        springJoint.frequency = 15.0
        springJoint.damping = 10.0
            
            self.scene?.physicsWorld.add(pin)
            self.scene?.physicsWorld.add(springJoint)
        
        }
        
        leftWheelAxel = SKSpriteNode(color: .darkGray, size: CGSize(width: 6, height: 60))
        leftWheelAxel.position = CGPoint(x: wheelNodeLeft.position.x, y: wheelNodeLeft.position.y + 30)
        leftWheelAxel.physicsBody = SKPhysicsBody(rectangleOf: leftWheelAxel.size)
        leftWheelAxel.physicsBody?.affectedByGravity = false
        leftWheelAxel.physicsBody?.allowsRotation = true
        leftWheelAxel.physicsBody?.isDynamic = true
        leftWheelAxel.zPosition = 4
        leftWheelAxel.physicsBody?.categoryBitMask = 0
        leftWheelAxel.physicsBody?.collisionBitMask = 0
        leftWheelAxel.physicsBody?.contactTestBitMask = 0
        
        
        //self.addChild(leftWheelAxel)
        
        
        //let leftWheelAxelTopPin = SKPhysicsJointFixed.joint(withBodyA: carNode.physicsBody!, bodyB: leftWheelAxel.physicsBody!, anchor: CGPoint(x: wheelNodeLeft.position.x, y: wheelNodeLeft.position.y + 60))
        
        
        let leftWheelAxelBottomPin = SKPhysicsJointPin.joint(withBodyA: wheelNodeLeft.physicsBody!, bodyB: carNode.physicsBody!, anchor: wheelNodeLeft.position)
        
        
        
        let rightWheelAxel = SKPhysicsJointPin.joint(withBodyA: carNode.physicsBody!, bodyB: wheelNodeRight.physicsBody!, anchor: wheelNodeRight.position)
    
        //print(headNode.zRotation)
        
        
        //self.scene?.physicsWorld.add(leftWheelAxelTopPin)
        self.scene?.physicsWorld.add(leftWheelAxelBottomPin)
        self.scene?.physicsWorld.add(rightWheelAxel)
    }
    public func addDownThruster() {
        thruster = FlameNode()
        thruster.position.y = carNode.frame.maxY + thruster.frame.size.height/2
        thruster.position.x = carNode.frame.midX
        thruster.zRotation = carNode.zRotation
        thruster.zPosition = -1
        
        self.addChild(thruster)
        
        attachment = SKPhysicsJointFixed.joint(withBodyA: thruster.physicsBody!, bodyB: carNode.physicsBody!, anchor: CGPoint(x: thruster.frame.midX, y: thruster.frame.minY))
        self.scene?.physicsWorld.add(attachment)
        thruster.turnOnThrusters()
        self.wheelNodeRight.physicsBody?.friction = 20
        self.wheelNodeLeft.physicsBody?.friction = 20
        //self.wheelNodeLeft.run(SKAction.applyForce(CGVector(dx:0,dy:-1000), at: wheelNodeLeft.position, duration: 100))
        //self.wheelNodeRight.run(SKAction.applyForce(CGVector(dx:0,dy:-1000), at: wheelNodeRight.position, duration: 100))
        
    }
    public func removeDownThruster() {
        print("running remove down thrust")
        self.scene?.physicsWorld.remove(attachment)
        thruster.turnOffThrusters()
        self.wheelNodeRight.physicsBody?.friction = 0.6
        self.wheelNodeLeft.physicsBody?.friction = 0.6
        
    }
    
    public func applyDriveForce(power:CGFloat) {
        wheelNodeRight.physicsBody?.applyTorque(-power)
        wheelNodeLeft.physicsBody?.applyTorque(-power)
    }
    
    public func addAndRaiseSuperShocks() {
        
        
        let superShock = SKSpriteNode(color: .darkGray, size: CGSize(width: 40, height: 20))
        superShock.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 20))
        superShock.position = CGPoint(x:carNode.frame.midX, y:carNode.frame.minY - 10)
        superShock.physicsBody?.allowsRotation = true
        superShock.physicsBody?.isDynamic = true
        superShock.physicsBody?.affectedByGravity = true
        superShock.physicsBody?.categoryBitMask = BitMasks.carMask
        superShock.physicsBody?.contactTestBitMask = 0
        superShock.physicsBody?.collisionBitMask = BitMasks.floorMask
        
        
        self.addChild(superShock)
        
        let superShockAttachment = SKPhysicsJointFixed.joint(withBodyA: carNode.physicsBody!, bodyB: superShock.physicsBody!, anchor: CGPoint(x: superShock.frame.midX, y: superShock.frame.maxY))
        self.scene?.physicsWorld.add(superShockAttachment)
        
        
        let extend = SKAction.group([SKAction.resize(toHeight: 200, duration: 0.3),SKAction.moveBy(x: 0, y: -180, duration: 0.3)])
        let retract = SKAction.group([SKAction.resize(toHeight: 20, duration: 0.3),SKAction.moveBy(x: 0, y: 180, duration: 0.3)])
        let wholeAction = SKAction.sequence([extend,retract,SKAction.removeFromParent()])
        superShock.run(wholeAction)
        carNode.run(SKAction.applyImpulse(CGVector(dx:0,dy:300000), duration: 0.5))
        
    }
   
    
    
    
    
    
    
}


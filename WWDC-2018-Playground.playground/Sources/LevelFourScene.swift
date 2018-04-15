//
//  LevelFourScene.swift
//  helperForCarGame
//
//  Created by Aryeh Greenberg on 3/21/18.
//  Copyright © 2018 Aryeh Greenberg. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

public class LevelFourScene: SKScene, SKPhysicsContactDelegate {
    private var car:AppleCarWithWheels!
    private var cam:SKCameraNode!
    private var buttonPressed = false
    private var launchButton:SKSpriteNode!
    private var rocketLaunched = false
    private var speechSynthesizer:AVSpeechSynthesizer!
    private var movingRocket = false
    private var sawTesla = false
    
    public override func didMove(to view: SKView) {
        cam = self.childNode(withName: "//cameraNode") as! SKCameraNode
        
        
        self.camera = cam
        
        car = AppleCarWithWheels(scene:self,withTim:false)
        car.position = CGPoint(x: 0, y: 100)
        car.zRotation = CGFloat.pi/2
        car.carNode.physicsBody?.allowsRotation = false
        
        launchButton = SKSpriteNode(imageNamed: "launchButtonDepressed")
        launchButton.size = CGSize(width: 100, height: 100)
        launchButton.name = "launchButton"
        launchButton.position = CGPoint(x: 0, y: -self.frame.size.height/2 + 60)
        launchButton.zPosition = 20
        cam.addChild(launchButton)
        
        speakIntro()
        
        //540,1800
        
        let roadsterNode = self.childNode(withName:"//roadsterNode") as! SKSpriteNode
        let path = CGPath(ellipseIn: CGRect(x:-600,y:1700,width:300,height:300), transform: nil)
        let action = SKAction.repeatForever(SKAction.follow(path, asOffset: false, orientToPath: true, duration: 2))
        roadsterNode.run(action)
        
        self.physicsWorld.contactDelegate = self
        
        
    }
    public func didBegin(_ contact: SKPhysicsContact) {
        if !sawTesla {
            print("contact between \(contact.bodyA), and \(contact.bodyB)")
            sawTesla = true
            speechSynthesizer = AVSpeechSynthesizer()
            let voice = AVSpeechSynthesisVoice(language: "en-GB")
            let speechUtterance = AVSpeechUtterance(string: "Hey look, it's Mr Musk's Tesla!")
            speechUtterance.rate = 0.5
            speechUtterance.voice = voice
            speechUtterance.postUtteranceDelay = 0.0
            speechSynthesizer.speak(speechUtterance)
        }
    }
    
    private var spoke = false
    private func speakIntro() {
        if !spoke {
            spoke = true
            speechSynthesizer = AVSpeechSynthesizer()
            let voice = AVSpeechSynthesisVoice(language: "en-GB")
            let speechUtterance = AVSpeechUtterance(string: "We are running out of time, so we will skip to the most novel feature of the I car. It doubles as a rocket, and we will launch it, under it's own power, to Pluto. Take that Elon Musk! Ha Ha Ha. Hit the big red button when you are ready.")
            speechUtterance.rate = 0.5
            speechUtterance.voice = voice
            speechUtterance.postUtteranceDelay = 0.0
            speechSynthesizer.speak(speechUtterance)
        }
        
    }
    
    public func launch() {
        //let fireNode = SKSpriteNode(imageNamed: "flameTwo")
        //fireNode.zRotation = CGFloat.pi
        //fireNode.run(SKAction.)
        let flame = FlameNode()
        flame.position = CGPoint(x:car.carNode.frame.minX - flame.frame.size.width/2, y:car.carNode.frame.midY)
        flame.physicsBody?.pinned = true
        flame.zRotation = CGFloat.pi/2
        flame.zPosition = -1
        flame.turnOnThrusters()
        
        print("Mass of car is \(getMassOfNode(node: car))")
        car.carNode.run(SKAction.applyForce(CGVector(dx:0,dy: 165000), duration: 100))
        
        car.carNode.addChild(flame)
        
        let thankYouNode = SKLabelNode(text: "Thank you for checking out my playground!")
        thankYouNode.position = CGPoint(x:0,y:self.frame.size.height/2 - 40)
        thankYouNode.fontSize = 40
        cam.addChild(thankYouNode)
        
    }
    
    public func getMassOfNode(node:SKNode) -> CGFloat {
        
        if node.children.count > 0 {
            var sum = node.physicsBody?.mass ?? 0
            for child in node.children {
                sum += getMassOfNode(node: child)
            }
            return sum
        }
        else {
            return node.physicsBody?.mass ?? 0
        }
    }
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let nodesAt = self.nodes(at: location)
            for node in nodesAt {
                //Act
                if node.name == "launchButton" {
                    if !rocketLaunched {
                        rocketLaunched = true
                        print("tapped launch button")
                        node.run(SKAction.setTexture(SKTexture(imageNamed: "launchButtonPressed")))
                        buttonPressed = true
                        launch()
                    }
                    
                }
                else {
                    if rocketLaunched && !self.isPaused {
                        car.carNode.position.y = -location.x
                        movingRocket = true
                    }
                    
                }
            }
        }
    }
    
    func speekOver() {
        let voice = AVSpeechSynthesisVoice(language: "en-GB")
        let speechUtterance = AVSpeechUtterance(string: "Good job, I can't wait to reveal the I car at WWDC, bye.")
        speechUtterance.rate = 0.5
        speechUtterance.voice = voice
        speechUtterance.postUtteranceDelay = 0.0
        speechSynthesizer.speak(speechUtterance)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movingRocket = false
        if buttonPressed {
            launchButton.run(SKAction.removeFromParent())
            buttonPressed = false
        }
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if movingRocket {
            for t in touches {
                let location = t.location(in: self)
                if !self.isPaused {
                    car.carNode.position.y = -location.x
                }
                
            }
            
        }
    }
    
    public override func didSimulatePhysics() {
        cam.position.y = car.carNode.position.x + 0.05 * car.carNode.position.x
        if cam.position.y >= 5650 {
            self.isPaused = true
            speekOver()
        }
    }
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        movingRocket = false
        if buttonPressed {
            launchButton.run(SKAction.removeFromParent())
            buttonPressed = false
        }
    }
    
}


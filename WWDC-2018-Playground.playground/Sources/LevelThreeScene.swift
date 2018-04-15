//
//  LevelThreeScene.swift
//  helperForCarGame
//
//  Created by Aryeh Greenberg on 3/21/18.
//  Copyright © 2018 Aryeh Greenberg. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

public class LevelThreeScene: SKScene, SKPhysicsContactDelegate, AVSpeechSynthesizerDelegate {
    private var carNode:SKSpriteNode!
    private var cam:SKCameraNode!
    private var accelerating:Bool!
    private var braking:Bool!
    private var car:AppleCarWithWheels!
    private var sliderNode:SliderNode!
    var speechSynthesizer:AVSpeechSynthesizer!
    private var downThrusterOn = false
    private var bgImage:SKSpriteNode!
    
    override public func didMove(to view: SKView) {
        
        print("scene 3 did move")
        cam = self.childNode(withName: "//cameraNode") as! SKCameraNode
        sliderNode = SliderNode()
        print("Scene size is \(self.size)")
        sliderNode.position = CGPoint(x: self.size.width/2 - 30, y: 0)
        sliderNode.locked = false
        //sliderNode.position = CGPoint(x:0,y:0)
        cam.addChild(sliderNode)
        
        FirstLevelScene.addFlipCarAndRestartButton(toScene: self, camera: cam)
        
        for child in cam.children {
            print(child.position)
        }
        
        self.physicsWorld.contactDelegate = self
        //carNode.addChild(cam)
        
        self.camera = cam
        
        accelerating = false
        braking = false
        
        car = AppleCarWithWheels(scene:self)
        car.position = CGPoint(x: -200, y: 0)
        //self.addChild(car)
        //car.addDownThruster()
        
        addBoosterButton()
        
        bgImage = cam.childNode(withName: "//bgImage") as! SKSpriteNode
       
        speakIntro()
        addSkipButton()
        
    }
    
    private func addSkipButton() {
        let skipButton = SKSpriteNode(imageNamed: "skipButton")
        skipButton.name = "skipButton"
        let xPosition = self.frame.size.width/2 - 10 - skipButton.frame.size.width/2
        var yPosition = self.frame.size.width/2 - 20
        yPosition -= skipButton.frame.size.width * 1.5
        skipButton.position = CGPoint(x: xPosition, y:yPosition)
        skipButton.zPosition = 10
        cam.addChild(skipButton)
    }
    
    private var spoke = false
    private func speakIntro() {
        if !spoke {
            spoke = true
            
            let mySpeechSynthesizer = AVSpeechSynthesizer()
            let voice = AVSpeechSynthesisVoice(language: "en-GB")
            let speechUtterance = AVSpeechUtterance(string: "Welcome to level three, we have another interesting obstacle for you here.")

            speechUtterance.rate = 0.5
            speechUtterance.voice = voice
            speechUtterance.postUtteranceDelay = 0.2
            mySpeechSynthesizer.speak(speechUtterance)
        }
    }
    
    
    
    override public func didSimulatePhysics() {
        cam.position.x = car.carNode.position.x + 400 < 6630 ?  car.carNode.position.x : 6230
        print("cam node position is \(cam.position.y)")
        if car.carNode.frame.maxY > 300 {
            cam.position.y = car.carNode.frame.maxY - 300
        }
        else {
            cam.position.y = 0
        }
        bgImage.position.x = -(car.carNode.position.x + 80) * 0.21206 + 668
        bgImage.position.y = cam.position.y < 1650 ? -cam.position.y * 0.1212121212 + 100: -100
        
    }
    
    
    override public func update(_ currentTime: TimeInterval) {
        //print(car.leftWheelAxel.frame)
        print(sliderNode.power)
        car.applyDriveForce(power: sliderNode.power)
        if sliderNode.power > 0 {
            car.startAccelerating()
        }
        else {
            car.stopAccelerating()
        }
        if sliderNode.power < 0 {
            car.startBraking()
        }
        else {
            car.stopBraking()
        }
        /*
         if accelerating {
         //print("accelerating")
         car.applyDriveForce(power:100)
         //car.carNode.physicsBody?.applyForce(CGVector(dx: 1000, dy: 0), at: CGPoint(x: car.carNode.frame.minX, y: car.carNode.frame.minY))
         
         //car.carNode.physicsBody.
         //carNode.physicsBody.
         }
         else if braking {
         car.applyDriveForce(power:-100)
         }*/
        
    }
    
    private var superShocksEnabled = false
    func enableSuperShocks() {
        if !superShocksEnabled {
            addSuperShocksButton()
            superShocksEnabled = true
            speechSynthesizer = AVSpeechSynthesizer()
            speechSynthesizer.delegate = self
            let voice = AVSpeechSynthesisVoice(language: "en-GB")
            let speechUtterance = AVSpeechUtterance(string: "The I car has a feature perfect for this! Try the super-shocks to get over the obstacle.")
            speechUtterance.rate = 0.5
            speechUtterance.voice = voice
            speechUtterance.postUtteranceDelay = 0.0
            speechSynthesizer.speak(speechUtterance)
        }
        
    }
    
    func addBoosterButton() {
        let button = SKSpriteNode(imageNamed: "downThrusterButtonOff")
        button.name = "downThrusterButton"
        let xCoord = -self.size.width/2 + button.frame.size.width/2 + 10
        let yCoord =  -self.size.height/2 + button.frame.size.height/2 + 10
        button.position = CGPoint(x: xCoord, y: yCoord)
        button.zPosition = 10
        cam.addChild(button)
        
    }
    func addSuperShocksButton() {
        print("Adding super shocks button")
        
        let button = SKSpriteNode(imageNamed: "superShocksButton")
        button.name = "superShocksButton"
        let xval = -self.size.width/2 + button.frame.size.width*1.5
        let yVal = -self.size.height/2 + button.frame.size.height/2 + 10
        button.position = CGPoint(x: xval + 20, y: yVal)
        button.zPosition = 10
        cam.addChild(button)
        
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: cam)
            let nodes = cam.nodes(at: location)
            for node in nodes {
                if node.name == "downThrusterButton" {
                    print("tapped down thruster")
                    if !downThrusterOn {
                        //enable
                        downThrusterOn = true
                        car.addDownThruster()
                        node.run(SKAction.setTexture(SKTexture(imageNamed: "downThrusterButtonOn")))
                    }
                    else {
                        downThrusterOn = false
                        car.removeDownThruster()
                        node.run(SKAction.setTexture(SKTexture(imageNamed: "downThrusterButtonOff")))
                    }
                }
                else if node.name == "superShocksButton" {
                    print("running super shocks")
                    car.addAndRaiseSuperShocks()
                }
                else if node.name == "flipButton" {
                    car.flip()
                }
                else if node.name == "restartButton" {
                    car.carNode.position = CGPoint(x: self.size.width/2 - 30, y: 0)
                    car.carNode.zRotation = 0
                    car.carNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    car.carNode.physicsBody?.angularVelocity = 0
                    car.wheelNodeLeft.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    car.wheelNodeLeft.physicsBody?.angularVelocity = 0
                    car.wheelNodeRight.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    car.wheelNodeRight.physicsBody?.angularVelocity = 0
                    
                }
                else if node.name == "skipButton" {
                    startLevelFour()
                }
            }
        }
    }
    private func startLevelFour() {
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            
            if let scene = LevelFourScene(fileNamed: "LevelFour") {
                print("found scene")
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                let myTransition = SKTransition.crossFade(withDuration: 0.8)
                //let reveal = SKTransition.reveal(with: .down, duration: 1)
                view.presentScene(scene, transition: myTransition)
            }
            
            
        }
    }
    private var levelOver = false
    
    public func didBegin(_ contact: SKPhysicsContact) {
        print("Did begin contact between \(contact.bodyA) and \(contact.bodyB)")
        //self.isPaused = true
        //endLevel()
        if contact.bodyA.node?.name == "trouble" ||  contact.bodyB.node?.name == "trouble" {
            print("Having trouble getting up the hill")
            enableSuperShocks()
        }
        else {
            self.isPaused = true
            if !levelOver {
                startLevelFour()
                levelOver = true
            }
            
        }
    }
}


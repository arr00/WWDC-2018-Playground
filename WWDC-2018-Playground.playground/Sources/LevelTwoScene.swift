//
//  LevelTwoScene.swift
//  helperForCarGame
//
//  Created by Aryeh Greenberg on 3/20/18.
//  Copyright © 2018 Aryeh Greenberg. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

public class LevelTwoScene: SKScene, SKPhysicsContactDelegate, AVSpeechSynthesizerDelegate {
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
        
        print("level two did move")
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
        bgImage = cam.childNode(withName: "//mountains") as! SKSpriteNode
        
    }
    
    
   
    override public func didSimulatePhysics() {
        cam.position.x = car.carNode.position.x + 400 < 6630 ?  car.carNode.position.x : 6230
        //print(car.carNode.position.x)
        if car.carNode.frame.maxY > 300 {
            cam.position.y = car.carNode.frame.maxY - 300
        }
        else {
            cam.position.y = 0
        }
        bgImage.position.x = -(car.carNode.position.x + 20) * 0.109511 + 349.5
        
    }
    
    
    override public func update(_ currentTime: TimeInterval) {
        //print(car.leftWheelAxel.frame)
        //print(sliderNode.power)
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
    
    private var downThrusterEnabled = false
    func enableDownThrusters() {
        if !downThrusterEnabled {
            addBoosterButton()
            downThrusterEnabled = true
            speechSynthesizer = AVSpeechSynthesizer()
            speechSynthesizer.delegate = self
            let voice = AVSpeechSynthesisVoice(language: "en-GB")
            let speechUtterance = AVSpeechUtterance(string: "So your having trouble with this hill. Thankfully, we thought of this. We installed a down thruster on the I car. Press the button on the bottom-left to enable it")
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
                else if node.name == "flipButton" {
                    print("flipping car")
                    car.flip()
                    /*
                    car.carNode.position.y += 100
                    car.carNode.zRotation = 0*/
                    //self.didMove(to: self.view!)
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
            }
        }
    }
    private func startLevelThree() {
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            
            if let scene = LevelThreeScene(fileNamed: "LevelThree") {
                print("found scene")
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                let myTransition = SKTransition.crossFade(withDuration: 0.8)
                //let reveal = SKTransition.reveal(with: .down, duration: 1)
                view.presentScene(scene, transition: myTransition)
            }
            
            
        }
        

    }
    
    private var gameOver = false
    
    public func didBegin(_ contact: SKPhysicsContact) {
        //print("Did begin contact between \(contact.bodyA) and \(contact.bodyB)")
        //self.isPaused = true
        //endLevel()
        if contact.bodyA.node?.name == "trouble" ||  contact.bodyB.node?.name == "trouble" {
            print("Having trouble getting up the hill")
            enableDownThrusters()
        }
        else {
            self.isPaused = true
            if !gameOver {
                gameOver = true
                startLevelThree()
            
            }
            
        }
    }
}

//
//  GameScene.swift
//  helperForCarGame
//
//  Created by Aryeh Greenberg on 3/18/18.
//  Copyright © 2018 Aryeh Greenberg. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation


public enum BitMasks {
    public static let floorMask:UInt32 = 2
    public static let carMask:UInt32 = 4
    public static let headMask:UInt32 = 8
    public static let finishFlagMask:UInt32 = 16
}


public class FirstLevelScene: SKScene, SKPhysicsContactDelegate, AVSpeechSynthesizerDelegate {
    
    private var carNode:SKSpriteNode!
    private var cam:SKCameraNode!
    private var accelerating:Bool!
    private var braking:Bool!
    private var car:AppleCarWithWheels!
    private var sliderNode:SliderNode!
    private var speechSynthesizer:AVSpeechSynthesizer!
    private var bgNode:SKSpriteNode!
    private var didFinishTalking = false
    
    
    override public func didMove(to view: SKView) {
        
        //playground music
        /*
        let audioPath = Bundle.main.path(forResource: "oorora", ofType: "mp3")
        let audioUrl = URL(fileURLWithPath: audioPath!)
        audioPlayer = try! AVAudioPlayer(contentsOf: audioUrl)
        audioPlayer.play()
        audioPlayer.numberOfLoops = -1
        audioPlayer.volume = 0.1*/
        
        
        // Get label node from scene and store it for use later
        
        //self.camera = camera
        print("scene did move")
        
        cam = self.childNode(withName: "//cameraNode") as! SKCameraNode
        sliderNode = SliderNode()
        print("Scene size is \(self.size)")
        sliderNode.position = CGPoint(x: self.size.width/2 - 30, y: 0)
        sliderNode.locked = false
        cam.addChild(sliderNode)
        
        
        
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
        
        //car.addedToParent()
        speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer.delegate = self
        let voice = AVSpeechSynthesisVoice(language: "en-GB")
        let speechUtterance = AVSpeechUtterance(string: "Welcome to our first location. On the left side, you'll see me sitting in the first I car prototype. On the right is your controller. Grab the slider and slide up to accelerate, slide down to decelerate and reverse. Activate the flip function by pressing the button in the top left corner. If you ever really mess up, press the restart button in the top right to restart. Go!")
        //0.5
        
        speechUtterance.rate = 0.5
        speechUtterance.voice = voice
        speechUtterance.postUtteranceDelay = 0.0
        speechSynthesizer.speak(speechUtterance)
        
        FirstLevelScene.addFlipCarAndRestartButton(toScene: self, camera: cam)
        
        bgNode = cam.childNode(withName: "//bgNode") as! SKSpriteNode
        
    }
    
    private var levelOver = false
    private func endLevel() {
        if !levelOver {
            levelOver = true
            let voice = AVSpeechSynthesisVoice(language: "en-GB")
            let speechUtterance = AVSpeechUtterance(string: "Congratulations! you made it, good luck on the next level!")
            speechUtterance.rate = 0.5
            speechUtterance.voice = voice
            speechUtterance.postUtteranceDelay = 0.0
            speechSynthesizer.speak(speechUtterance)
        }
        
    }
    
    private func startPlayingAccelerationSound() {
        car.startAccelerating()
        /*
         print("Playing acc")
         let brakeingNode = SKAudioNode(fileNamed: "eletric-Acceleration")
         brakeingNode.autoplayLooped = false
         brakeingNode.isPositional = true
         carNode.addChild(brakeingNode)
         
         Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (time) in
         brakeingNode.removeFromParent()
         if self.accelerating {
         self.startPlayingAccelerationSound()
         }
         }*/
        
    }
    
    
    
    
    private func touchDown(atPoint pos : CGPoint) {
        print(pos)
        /*
        if pos.x < 50 && pos.y < 50 {
            accelerating = true
            startPlayingAccelerationSound()
            
        }
        else if pos.x > 100 && pos.y > 100 {
            braking = true
            car.startBraking()
        }*/
        
        print("Received position")
        if cam.nodes(at: pos).count > 0 {
            print("There are nodes")
            for node in cam.nodes(at: pos) {
                if node.name == "flipButton" {
                    print("flipping car")
                    car.flip()
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
    /*
     func touchMoved(toPoint pos : CGPoint) {
     if let n = self.spinnyNode?.copy() as! SKShapeNode? {
     n.position = pos
     n.strokeColor = SKColor.blue
     self.addChild(n)
     }
     }*/
    
    private func touchUp(atPoint pos : CGPoint) {
        print(pos)
        accelerating = false
        braking = false
        
        car.stopBraking()
        car.stopAccelerating()
    }
    
    
    
    
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self.view)) }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self.view)) }
    }
    override public func didSimulatePhysics() {
        cam.position.x = car.carNode.position.x + 400 < 6630 ?  car.carNode.position.x : 6230
        
        //dont show past 6630
        
        if car.carNode.frame.maxY > 300 {
            cam.position.y = car.carNode.frame.maxY - 300
        }
        else {
            cam.position.y = 0
        }
        bgNode.position.x =  -(car.carNode.position.x + 400) * 0.1 + 311
        //0.09873016
        
    }
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: cam)) }
    }
    
    
    override public func update(_ currentTime: TimeInterval) {
       //print(car.leftWheelAxel.frame)
        let coefficent:CGFloat = didFinishTalking ? 1:0.2
        car.applyDriveForce(power: sliderNode.power * coefficent)
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
    
    public func didBegin(_ contact: SKPhysicsContact) {
        print("Did begin contact between \(contact.bodyA) and \(contact.bodyB)")
        self.isPaused = true
        endLevel()
    }
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        didFinishTalking = true
        
        sliderNode.locked = false
        if utterance.speechString == "Congratulations! you made it, good luck on the next level!" {
            startLevelTwo()
        }
    }
    private func startLevelTwo() {
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            
            if let scene = LevelTwoScene(fileNamed: "LevelTwo") {
                print("found scene")
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                let myTransition = SKTransition.crossFade(withDuration: 0.8)
                //let reveal = SKTransition.reveal(with: .down, duration: 1)
                view.presentScene(scene, transition: myTransition)
            }
            
            
        }
    }
    
    public static func addFlipCarAndRestartButton(toScene:SKScene, camera:SKCameraNode) {
        let flipCarNode = SKSpriteNode(imageNamed: "flipButton")
        flipCarNode.name = "flipButton"
        flipCarNode.position = CGPoint(x: -toScene.frame.size.width/2 + 10 + flipCarNode.frame.size.width/2, y:toScene.frame.size.height/2 - flipCarNode.frame.size.height/2 - 10)
        flipCarNode.zPosition = 10
        
        
        let restartNode = SKSpriteNode(imageNamed: "restartButton")
        restartNode.name = "restartButton"
        restartNode.position = CGPoint(x: toScene.frame.size.width/2 - 10 - flipCarNode.frame.size.width/2, y:toScene.frame.size.height/2 - flipCarNode.frame.size.height/2 - 10)
        restartNode.zPosition = 10
        
        camera.addChild(restartNode)
        camera.addChild(flipCarNode)
    }
    
    
}


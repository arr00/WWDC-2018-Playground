//
//  TimeCookPresentation.swift
//  helperForCarGame
//
//  Created by Aryeh Greenberg on 3/24/18.
//  Copyright © 2018 Aryeh Greenberg. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

public class TimCookPresentation: SKScene, AVSpeechSynthesizerDelegate  {

    var speechSynthesizer:AVSpeechSynthesizer!
    
    override public func didMove(to view: SKView) {
        //let timCookNode = SKSpriteNode(imageNamed: ti)
        speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer.delegate = self
        let mouthNode = self.childNode(withName: "//mouthNode")
        let action = SKAction.sequence([SKAction.moveBy(x: 0, y: -20, duration: 0.15),SKAction.moveBy(x: 0, y: 20, duration: 0.15)])
        let forever = SKAction.repeatForever(action)
        mouthNode?.run(forever)
        
        startSpeaking()
    }
    
    
    private func startSpeaking() {
        let voice = AVSpeechSynthesisVoice(language: "en-GB")
        let speechUtterance = AVSpeechUtterance(string: "Hello, and Good morning! Today you will help me test drive the brand new Apple I Car in preperation for WWDC 2018. I will be guiding you along the way, good luck!")
        speechUtterance.voice = voice
        speechUtterance.postUtteranceDelay = 0.4
        //rate is 0.5
        speechUtterance.rate = 0.5
        speechUtterance.preUtteranceDelay = 0.0
        speechSynthesizer.speak(speechUtterance)
    }
    private func startFirstScene() {
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            
            if let scene = FirstLevelScene(fileNamed: "FirstLevel") {
                print("found scene")
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                let myTransition = SKTransition.crossFade(withDuration: 0.2)
                //let reveal = SKTransition.reveal(with: .down, duration: 1)
                view.presentScene(scene, transition: myTransition)
            }
            
            
        }
    }
    
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("started")
        
    }
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("finished utterance")
        if utterance.speechString == "Hello, and Good morning! Today you will help me test drive the brand new Apple I Car in preperation for WWDC 2018. I will be guiding you along the way, good luck!" {
            startFirstScene()
        }
        
        
    }
}

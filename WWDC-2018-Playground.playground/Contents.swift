//: Playground - noun: a place where people can play

import UIKit
import SpriteKit
import PlaygroundSupport
import AVFoundation


let view = SKView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))
    // Load the SKScene from 'GameScene.sks'
    
    if let scene = TimCookPresentation(fileNamed: "TimCookPresentation") {
    //if let scene = LevelFourScene(fileNamed:"LevelFour") {
        print("found scene")
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFit
        
        // Present the scene
        view.presentScene(scene)
    }
    
    view.isMultipleTouchEnabled = true
    view.ignoresSiblingOrder = true
    view.contentMode = .scaleToFill
    view.showsFPS = true
    view.showsNodeCount = true






    
    PlaygroundPage.current.liveView = view
    



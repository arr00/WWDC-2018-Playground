//
//  SliderNode.swift
//  helperForCarGame
//
//  Created by Aryeh Greenberg on 3/20/18.
//  Copyright © 2018 Aryeh Greenberg. All rights reserved.
//

//import UIKit
import SpriteKit

public class SliderNode: SKNode {
    
    private var holding = false
    private var sliderNode:SKSpriteNode
    private var backgroundView:SKSpriteNode
    public var locked = false
    
    public var power:CGFloat {
        get {
            return sliderNode.frame.midY * 0.75
        }
    }
    
    public override init() {
        
        
        backgroundView = SKSpriteNode(imageNamed: "sliderFrame")
        backgroundView.size.width = 30
        backgroundView.size.height = 400
        backgroundView.zPosition = 10
        backgroundView.position = CGPoint(x: 0, y: 0)
        
        sliderNode = SKSpriteNode(imageNamed: "slider")
        sliderNode.size.width = 60
        sliderNode.size.height = 60
        sliderNode.position = CGPoint(x: 0, y: 0)
        sliderNode.zPosition = 11
        
        super.init()
        self.isUserInteractionEnabled = true
        self.zPosition = 11
        self.addChild(backgroundView)
        self.addChild(sliderNode)
        
    }
   
    private func touchDown(atPoint:CGPoint) {
      
        if atPoint.x > sliderNode.frame.minX && atPoint.x < sliderNode.frame.maxX && atPoint.y > sliderNode.frame.minY && atPoint.y < sliderNode.frame.maxY {
            holding = true
        }
    }
    private func touchMoved(atPoint:CGPoint) {
        if !locked && holding && atPoint.y > backgroundView.frame.minY && atPoint.y < backgroundView.frame.maxY {
            sliderNode.position.y = atPoint.y
        }
        else if !locked && holding && atPoint.y > backgroundView.frame.maxY {
            sliderNode.position.y = backgroundView.frame.maxY
        }
        else if !locked && holding && atPoint.y < backgroundView.frame.minY {
            sliderNode.position.y = backgroundView.frame.minY
        }
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))

        }
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {self.touchMoved(atPoint: t.location(in: self))}
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        holding = false
        sliderNode.position = backgroundView.position
    }
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        holding = false
        sliderNode.position = backgroundView.position
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

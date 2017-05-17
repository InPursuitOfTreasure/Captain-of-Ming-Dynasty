//
//  HnsPrefightScene.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/5/15.
//  Copyright © 2017年 hns. All rights reserved.
//

import Foundation
import SpriteKit

class HnsPreFightScene: SKScene
{
    let preFightHandle = HnsPreFightHandle()
    let backgroundNode = SKSpriteNode.init(imageNamed: "preFight")
    let buttonNormal = SKSpriteNode.init(imageNamed: "buttonNormal")
    let buttonGray = SKSpriteNode.init(imageNamed: "buttonGray")
    let textNormal = SKLabelNode.init(fontNamed: "STKaiti")
    let textGray = SKLabelNode.init(fontNamed: "STKaiti")
    let textPoints = SKLabelNode.init(fontNamed: "STKaiti")
    let pointArr = [SKLabelNode.init(fontNamed: "STKaiti"),
                    SKLabelNode.init(fontNamed: "STKaiti"),
                    SKLabelNode.init(fontNamed: "STKaiti"),]
    let buttonStart = SKSpriteNode.init(imageNamed: "btn_start_n")
    let addNameArr = ["1",
                      "2",
                      "3",
                      "4",
                      "5",
                      "6",]
    var clickNode: SKSpriteNode?
    var points: Int = 10
    
    func clickAddBegin()
    {
        clickNode?.colorBlendFactor = 0.5
        
        let nameValue: Int = Int((clickNode?.name)!)!
        if nameValue > 3
        {
            if points <= 0
            {
                return
            }
            points -= 1
            textPoints.text = String(points)
            let point: Int = Int(pointArr[nameValue - 4].text!)!
            pointArr[nameValue - 4].text = String(point + 1)
        }
        else
        {
            if points >= 10
            {
                return
            }
            points += 1
            textPoints.text = String(points)
            let point: Int = Int(pointArr[nameValue - 1].text!)!
            pointArr[nameValue - 1].text = String(point - 1)
        }
    }
    func clickAddEnd()
    {
        clickNode?.colorBlendFactor = 0
    }
    func clickGray()
    {
        let position: CGPoint = buttonGray.position
        buttonGray.position = buttonNormal.position
        buttonNormal.position = position
        if textGray.name == "gray"
        {
            textGray.name = nil
            textNormal.name = "gray"
        }
        else
        {
            textGray.name = "gray"
            textNormal.name = nil
        }
    }
    func clickStartBegin()
    {
        buttonStart.colorBlendFactor = 0.5
    }
    func clickStartEnd()
    {
        buttonStart.colorBlendFactor = 0
        let scene = HnsFightScene()
        scene.size = self.size
        preFightHandle.setDataOfFightScene(scene1: scene, scene2: self)
        //let doors = SKTransition.fade(withDuration: 0.7)
        //self.view?.presentScene(scene, transition: doors)
        self.view?.presentScene(scene)
    }
    
    func createAddButton()
    {
        for i in 0...2
        {
            let node = preFightHandle.initAddNode(name: addNameArr[i], isFlip: false, positionX: i * 210 + 110, positionY: 200)
            self.addChild(node)
        }
        for i in 0...2
        {
            let node = preFightHandle.initAddNode(name: addNameArr[i+3], isFlip: true, positionX: i * 210 + 215, positionY: 200)
            self.addChild(node)
        }
    }
    func createBackground()
    {
        backgroundNode.anchorPoint = CGPoint.init(x: 0, y: 0)
        backgroundNode.zPosition = -1
        backgroundNode.size = self.size
        backgroundNode.position = CGPoint.init(x: 0, y: 0)
        self.addChild(backgroundNode)
    }
    func createButton()
    {
        buttonNormal.size = CGSize.init(width: 100, height: 40)
        buttonNormal.position = CGPoint.init(x: 125, y: 360)
        buttonNormal.zPosition = 1
        self.addChild(buttonNormal)
        
        textNormal.text = "披坚"
        textNormal.position = CGPoint.init(x: 125, y: 350)
        textNormal.zPosition = 2
        textNormal.fontSize = 24
        textNormal.fontColor = SKColor.black
        self.addChild(textNormal)
        
        buttonGray.size = CGSize.init(width: 100, height: 40)
        buttonGray.position = CGPoint.init(x: 250, y: 360)
        buttonGray.zPosition = 1
        buttonGray.name = "gray"
        self.addChild(buttonGray)
        
        textGray.text = "执锐"
        textGray.position = CGPoint.init(x: 250, y: 350)
        textGray.zPosition = 2
        textGray.fontSize = 24
        textGray.fontColor = SKColor.black
        textGray.name = "gray"
        self.addChild(textGray)
    }
    func createPintArray()
    {
        for i in 0...2
        {
            let node = pointArr[i]
            node.text = "0"
            node.position = CGPoint.init(x: i*210 + 162, y: 188)
            node.fontSize = 30
            node.fontColor = SKColor.black
            self.addChild(node)
        }
    }
    func createStart()
    {
        buttonStart.size = CGSize.init(width: 200, height: 80)
        buttonStart.position = CGPoint.init(x: (self.view?.frame.midX)!, y: 80)
        buttonStart.color = .darkGray
        buttonStart.name = "start"
        self.addChild(buttonStart)
    }
    func createTextPoints()
    {
        textPoints.text = String(points)
        textPoints.position = CGPoint.init(x: 670, y: 325)
        textPoints.fontSize = 24
        textPoints.fontColor = SKColor.black
        textPoints.horizontalAlignmentMode = .left
        self.addChild(textPoints)
    }
    
    override func didMove(to view: SKView)
    {
        createAddButton()
        createBackground()
        createButton()
        createPintArray()
        createStart()
        createTextPoints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touches = touches as NSSet
        let touch = touches.anyObject() as! UITouch
        let location = touch.location(in: self)
        let node = atPoint(location) as? SKSpriteNode
        var textNode: SKLabelNode?
        if node == nil
        {
            textNode = atPoint(location) as? SKLabelNode
        }
        
        if node?.name == "start"
        {
            clickNode = node
            clickStartBegin()
        }
        else if node?.name == "gray" || textNode?.name == "gray"
        {
            clickGray()
        }
        else if node?.name != nil
        {
            clickNode = node
            for name in addNameArr
            {
                if name == node?.name
                {
                    clickAddBegin()
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if clickNode?.name == "start"
        {
            clickStartEnd()
        }
        else
        {
            clickAddEnd()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touches = touches as NSSet
        let touch = touches.anyObject() as! UITouch
        let location = touch.location(in: self)
        print(location)
    }
}

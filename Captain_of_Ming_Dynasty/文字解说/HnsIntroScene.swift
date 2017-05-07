//
//  HnsIntroSence.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/5/3.
//  Copyright © 2017年 hns. All rights reserved.
//

import Foundation
import SpriteKit

class HnsIntroScene: SKScene
{
    static let introScene = HnsIntroScene.init()
    var introNode: Array<SKLabelNode> = [
        SKLabelNode(fontNamed:"STKaiti"),
        SKLabelNode(fontNamed:"STKaiti"),
        SKLabelNode(fontNamed:"STKaiti"),
        SKLabelNode(fontNamed:"STKaiti"),
        SKLabelNode(fontNamed:"STKaiti"),
        SKLabelNode(fontNamed:"STKaiti"),
        SKLabelNode(fontNamed:"STKaiti"),
        ]
    var textArray: Array<String>?
    var nextScene: SKScene?
    
    var animationText: String?
    var animationNode: SKLabelNode?
    var animationShow = 0
    
    var timer: Timer?
    var i = 0
    var j = 0
    var tag = 0
    
    func create_background_textNode()
    {
        DispatchQueue(label: "com.hns.introQueue").async
            {
                let backNode = SKSpriteNode(imageNamed: "background.jpg")
                backNode.anchorPoint = CGPoint.zero
                backNode.position = CGPoint(x: 0, y: 0)
                backNode.zPosition = -1;
                
                var y = 350
                var node: SKLabelNode
                for i in 0 ... self.introNode.count-1 {
                    node = self.introNode[i]
                    node.position = CGPoint.init(x: 100, y: y)
                    node.fontSize = 24
                    node.fontColor = SKColor.black
                    node.horizontalAlignmentMode = .left
                    y -= 50
                }
                
                DispatchQueue.main.async
                    {
                        self.addChild(backNode)
                        for i in 0 ... self.introNode.count-1
                        {
                            self.addChild(self.introNode[i])
                        }
                }
        }
    }
    
    override func didMove(to view: SKView)
    {
        textArray = setTextArrayByTag(tag: tag)
        setString(text: (textArray?[i])!, node: introNode[j])
    }
    
    func handleText()
    {
        if animationShow < (animationText?.characters.count)!
        {
            animationShow += 1
            let index = animationText?.index((animationText?.startIndex)!, offsetBy: animationShow)
            animationNode?.text = animationText?.substring(to: index!)
        }
        else
        {
            animationShow = 0
            removeTimer()
            i += 1
            j += 1
            
            if i < (textArray?.count)!
            {
                if j == 7
                {
                    sleep(1)
                    j = 0
                    for item in introNode {
                        item.text = ""
                    }
                }
                setString(text: (textArray?[i])!, node: introNode[j])
            }
            else
            {
                willPresentNextScene()
            }
        }
    }
    
    func presentNextScene()
    {
        nextScene?.size = self.size
        let doors = SKTransition.fade(withDuration: 0.7)
        self.view?.presentScene(nextScene!, transition: doors)
        
        for item in introNode {
            item.text = ""
        }
        textArray = nil
        nextScene = nil
        
        animationText = ""
        animationNode = nil
        animationShow = 0
        
        i = 0
        j = 0
        
        removeTimer()
    }
    
    func removeTimer()
    {
        timer?.invalidate()
        timer = nil
    }
    
    func setString(text: String, node: SKLabelNode)
    {
        if (timer == nil)
        {
            animationText = text
            animationNode = node
            timer = Timer.init(timeInterval: 0.07, target: self, selector: #selector(handleText), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        presentNextScene()
    }
    
    func willPresentNextScene()
    {
        if (timer == nil)
        {
            timer = Timer.init(timeInterval: 2, target: self, selector: #selector(presentNextScene), userInfo: nil, repeats: false)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        }
    }
}

//
//  GameScene.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 16/9/13.
//  Copyright (c) 2016年 hns. All rights reserved.
//

import SpriteKit

func die()
{
    HnsMapScene.mapScene.removeTimer()
    HnsMapHandle().reset()
    HnsTimeHandle().getTimeDic()
    HnsSqlite3.sqlHandle.deleteData()
    HnsInnerScene.innerScene.reloadNpc()
}

class GameScene: SKScene
{
    override func didMove(to view: SKView)
    {
        let loginQueue = DispatchQueue(label: "com.hns.loginQueue", attributes: .concurrent)
        
        loginQueue.async
        {
            let backNode = SKSpriteNode(imageNamed: "background.jpg")
            backNode.anchorPoint = CGPoint.zero
            backNode.position = CGPoint(x: 0, y: 0)
            backNode.zPosition = -1;
            
            DispatchQueue.main.async
            {
                self.addChild(backNode)
            }
        }
        
        loginQueue.async
        {
            let myLabel1 = SKLabelNode(fontNamed:"STKaiti")
            myLabel1.text = "大明百夫长"
            myLabel1.fontColor = SKColor.black
            myLabel1.fontSize = 45
            myLabel1.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
            
            DispatchQueue.main.async
            {
                self.addChild(myLabel1)
            }
        }
    
        loginQueue.async
        {
            let myLabel2 = SKLabelNode(fontNamed:"Chalkduster")
            myLabel2.text = "Captain of Ming Dynasty"
            myLabel2.fontColor = SKColor.black
            myLabel2.fontSize = 45
            myLabel2.position = CGPoint(x:self.frame.midX, y:self.frame.midY+60)
            
            DispatchQueue.main.async
            {
                self.addChild(myLabel2)
            }
        }
    }
    
    func showGame()
    {
        let doors = SKTransition.fade(withDuration: 0.7)
        self.view?.presentScene(HnsMapScene.mapScene, transition: doors)
    }
    
    func showIntro()
    {
        HnsIntroScene.introScene.nextScene = HnsMapScene.mapScene
        HnsIntroScene.introScene.tag = 0
        
        let doors = SKTransition.fade(withDuration: 0.7)
        self.view?.presentScene(HnsIntroScene.introScene, transition: doors)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let filePath: String = NSHomeDirectory() + "/Documents/save.plist"
        print(filePath)
        var dic = NSDictionary(contentsOfFile: filePath)
        
        if dic == nil
        {
            HnsMapHandle().reset()
            dic = NSDictionary(contentsOfFile: filePath)
            showIntro()
        }
        else
        {
            let time = HnsTimeHandle().getTimeDicAsNumber()
            if time == 16280301
            {
                showIntro()
            }
            else
            {
                showGame()
            }
        }
        
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}

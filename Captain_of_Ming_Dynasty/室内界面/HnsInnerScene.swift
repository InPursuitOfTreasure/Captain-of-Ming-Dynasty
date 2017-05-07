//
//  HnsInnerScene.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/5/6.
//  Copyright © 2017年 hns. All rights reserved.
//

import Foundation
import SpriteKit

class HnsInnerScene: SKScene
{
    static let innerScene = HnsInnerScene()
    
    var npcArray: Array<HnsNpc> = [HnsNpc(),
                                   HnsNpc(),
                                   HnsNpc(),
                                   HnsNpc(),
                                   HnsNpc(),
                                   HnsNpc(),
                                   HnsNpc(),]
    var tag = 1
    var meNode = SKSpriteNode.init(texture: texture3)
    var npcNode = SKSpriteNode(imageNamed: "npc4")
    var bedNode = SKSpriteNode.init(imageNamed: "bed1")
    var talkNode = SKSpriteNode.init(imageNamed: "talk")
    var talkText = SKLabelNode.init(fontNamed: "STKaiti")
    var taskNodeArr = [SKSpriteNode.init(imageNamed: "task1"),
                       SKSpriteNode.init(imageNamed: "task2"),
                       SKSpriteNode.init(imageNamed: "task3"),
                       SKSpriteNode.init(imageNamed: "task4"),
                       SKSpriteNode.init(imageNamed: "task5"),]
    
    func create_background_npcNode()
    {
        DispatchQueue(label: "com.hns.innerQueue").async
            {
                let backNode = SKSpriteNode(imageNamed: "inner")
                backNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                backNode.zPosition = -1
                backNode.size = self.size
                
                self.npcNode.size = CGSize(width: 100, height: 100)
                self.npcNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                self.npcNode.zPosition = 100
                self.npcNode.name = "npc"
           
                DispatchQueue.main.async
                    {
                        self.addChild(backNode)
                        self.addChild(self.npcNode)
                }
        }
    }
    
    func createBedNode()
    {
        bedNode.size = CGSize(width: 150, height: 150)
        bedNode.position = CGPoint(x: 600, y: 100)
        bedNode.isHidden = true
        self.addChild(bedNode)
    }
    
    func createMeNode()
    {
        meNode.size = CGSize(width: 100, height: 100)
        meNode.position = CGPoint(x: self.frame.midX, y: 50)
        meNode.zPosition = 150;
        meNode.name = "me"
        self.addChild(meNode)
    }
    
    func createTalk()
    {
        talkNode.size = CGSize(width: 200, height: 100)
        talkNode.position = CGPoint(x: self.frame.midX+100, y: self.frame.midY+50)
        talkNode.zPosition = 120
        talkNode.isHidden = true
        self.addChild(talkNode)
        
        talkText.position = CGPoint(x: self.frame.midX+100, y: self.frame.midY+50)
        talkText.fontSize = 24
        talkText.fontColor = SKColor.black
        talkText.zPosition = 150
        self.addChild(talkText)
        
        for i in 0 ... taskNodeArr.count-1
        {
            let node = taskNodeArr[i]
            node.size = CGSize(width: 100, height: 40)
            node.position = CGPoint(x: self.frame.midX-100, y: self.frame.midY)
            node.zPosition = 130
            node.isHidden = true
            node.name = "task" + String(i)
            self.addChild(node)
        }
    }
    
    override func didMove(to view: SKView)
    {
        if npcArray[tag-1].wealth > 50
        {
            bedNode.isHidden = false
        }
        talkText.text = ""
        talkNode.isHidden = true
        let i = npcArray[tag-1].dailyTask
        if i != 0
        {
            taskNodeArr[i - 1].isHidden = true
        }
    }
    
    func reloadNpc()
    {
        for i in 0 ... npcArray.count-1
        {
            HnsSqlite3.sqlHandle.loadData(tag: i + 1, npc: npcArray[i])
        }
    }
    
    func saveToDB()
    {
        for i in 0 ... npcArray.count-1
        {
            HnsSqlite3.sqlHandle.updateData(tag: i+1, npc: npcArray[i])
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let hnsTouches = touches as NSSet
        let touch = hnsTouches.anyObject() as! UITouch
        let node = atPoint(touch.location(in: self)) as? SKSpriteNode
        
        if node?.name == "npc"
        {
            talkText.text = talkString()
            talkNode.isHidden = false
            let i = npcArray[tag-1].dailyTask
            if i != 0
            {
                taskNodeArr[i - 1].isHidden = false
            }
        }
        else if node?.name == "me"
        {
            self.view?.presentScene(HnsMapScene.mapScene)
        }
        else if node?.name == "task0"
        {
            var wood = HnsTask.goodDic["wood"]! as Int
            if wood > 0
            {
                talkText.text = taskString(key: "99")
                talkNode.isHidden = false
                npcArray[tag-1].dailyTask = 0
                npcArray[tag-1].will += 10
                taskNodeArr[1].isHidden = true
                wood -= 1
                HnsTask.goodDic["wood"] = wood
            }
            else
            {
                talkText.text = taskString(key: "00")
                talkNode.isHidden = false
            }
        }
        else if node?.name == "task1"
        {
            talkText.text = taskString()
            talkNode.isHidden = false
            npcArray[tag-1].dailyTask = 0
            npcArray[tag-1].will += 5
            taskNodeArr[1].isHidden = true
        }
        else if node?.name == "task2"
        {
            let silver = HnsTask.goodDic["silver"]! as Int
            let food = HnsTask.goodDic["food"]! as Int
            if silver > 20
            {
                let r = arc4random() % 10
                talkText.text = taskString(key: "99")
                talkNode.isHidden = false
                npcArray[tag-1].dailyTask = 0
                npcArray[tag-1].will += 10
                taskNodeArr[2].isHidden = true
                HnsTask.goodDic["silver"] = silver - Int(r)
                HnsTask.goodDic["food"] = food + Int(r * 10)
            }
            else
            {
                talkText.text = taskString(key: "00")
                talkNode.isHidden = false
            }
        }
        else if node?.name == "task3"
        {
            let food = HnsTask.goodDic["food"]! as Int
            if food > 0
            {
                talkText.text = taskString(key: "99")
                talkNode.isHidden = false
                npcArray[tag-1].dailyTask = 0
                taskNodeArr[3].isHidden = true
                HnsTask.goodDic["food"] = food - 10
            }
            else
            {
                talkText.text = taskString(key: "00")
                talkNode.isHidden = false
            }
        }
        else if node?.name == "task4"
        {
            var iron = HnsTask.goodDic["iron"]! as Int
            if iron > 0
            {
                talkText.text = taskString(key: "99")
                talkNode.isHidden = false
                npcArray[tag-1].dailyTask = 0
                taskNodeArr[3].isHidden = true
                iron -= 10
                HnsTask.goodDic["iron"] = iron
            }
            else
            {
                talkText.text = taskString(key: "00")
                talkNode.isHidden = false
            }
        }
        else
        {
            talkText.text = ""
            talkNode.isHidden = true
            let i = npcArray[tag-1].dailyTask
            if i != 0
            {
                taskNodeArr[i - 1].isHidden = true
            }
        }
    }
    func talkString() -> String
    {
        let filePath: String = Bundle.main.path(forResource: "talk", ofType: "plist")!
        let dic = NSDictionary(contentsOfFile: filePath)
        let key: String = "0" + String(tag)
        let str = dic!.object(forKey: key) as! String
        return str
    }
    func taskString() -> String
    {
        let filePath: String = Bundle.main.path(forResource: "talk", ofType: "plist")!
        let dic = NSDictionary(contentsOfFile: filePath)
        let npc = npcArray[tag-1]
        let key = String(npc.dailyTask) + String(tag)
        let str = dic!.object(forKey: key) as! String
        return str
    }
    func taskString(key: String) -> String
    {
        let filePath: String = Bundle.main.path(forResource: "talk", ofType: "plist")!
        let dic = NSDictionary(contentsOfFile: filePath)
        return dic!.object(forKey: key) as! String
    }
}

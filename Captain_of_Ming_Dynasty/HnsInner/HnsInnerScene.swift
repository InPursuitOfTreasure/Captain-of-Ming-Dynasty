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
    var meNode = SKSpriteNode.init(texture: HnsMapScene.mapScene.texture3)
    var npcNode = SKSpriteNode(imageNamed: "npc4")
    var bedNode = SKSpriteNode.init(imageNamed: "bed1")
    var talkNode = SKSpriteNode.init(imageNamed: "talk")
    var talkText = SKLabelNode.init(fontNamed: "STKaiti")
    var taskNodeArr = [SKSpriteNode.init(imageNamed: "task1"),
                       SKSpriteNode.init(imageNamed: "task2"),
                       SKSpriteNode.init(imageNamed: "task3"),
                       SKSpriteNode.init(imageNamed: "task4"),
                       SKSpriteNode.init(imageNamed: "task5"),]
    var textNode: Array<SKLabelNode> = [
        SKLabelNode(fontNamed:"STKaiti"),
        SKLabelNode(fontNamed:"STKaiti"),
        SKLabelNode(fontNamed:"STKaiti"),
        ]
    var textBackground = SKSpriteNode.init(imageNamed: "textBackground_inner")
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
        
        let x = self.frame.midX
        var y = 300
        for i in 0 ... textNode.count - 1
        {
            textNode[i].fontSize = 24
            textNode[i].fontColor = SKColor.black
            textNode[i].position = CGPoint(x: x + 70, y: CGFloat(y))
            textNode[i].zPosition = 1004
            y -= 40
        }
        textBackground.size = CGSize(width: 200, height: 150)
        textBackground.position = CGPoint(x: x + 70, y: 270)
        textBackground.zPosition = 1000
        textBackground.isHidden = true
        
        for i in 0 ... textNode.count - 1
        {
            self.addChild(textNode[i])
        }
        self.addChild(textBackground)
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
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.view?.addGestureRecognizer(longpress)
    }
    
    func ifFinishTask()
    {
        var flag = true
        if HnsTask.task.progress != 1
        {
            return
        }
        for i in 0...HnsInnerScene.innerScene.npcArray.count-1
        {
            let npc = HnsInnerScene.innerScene.npcArray[i]
            if npc.dailyTask != 0
            {
                flag = false
            }
        }
        if flag
        {
            HnsTask.task.progress = 0
            HnsSqlite3.sqlHandle.loadtask(tid: HnsTask.task.tid+1, task: HnsTask.task)
        }
    }
    
    func longPress()
    {
        let npc = npcArray[tag-1]
        textNode[0].text = "姓名  " + npc.name
        textNode[1].text = "民心  " + String(npc.will)
        textNode[2].text = "财富  " + String(npc.wealth)
        self.textBackground.isHidden = false
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
        if textHidden()
        {
            return
        }
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
            let wood = HnsTask.goodDic["wood"]! as Int
            if wood > 0
            {
                talkText.text = taskString(key: "99")
                talkNode.isHidden = false
                npcArray[tag-1].dailyTask = 0
                npcArray[tag-1].will += 10
                taskNodeArr[1].isHidden = true
                HnsTask.goodDic["wood"] = wood - 10
                ifFinishTask()
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
            ifFinishTask()
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
                ifFinishTask()
            }
            else
            {
                talkText.text = taskString(key: "00")
                talkNode.isHidden = false
            }
        }
        else if node?.name == "task3"
        {
            let iron = HnsTask.goodDic["iron"]! as Int
            if iron > 0
            {
                talkText.text = taskString(key: "99")
                talkNode.isHidden = false
                npcArray[tag-1].dailyTask = 0
                npcArray[tag-1].will += 10
                taskNodeArr[3].isHidden = true
                HnsTask.goodDic["iron"] = iron - 30
                ifFinishTask()
            }
            else
            {
                talkText.text = taskString(key: "00")
                talkNode.isHidden = false
            }
        }
        else if node?.name == "task4"
        {
            let food = HnsTask.goodDic["food"]! as Int
            if food > 0
            {
                talkText.text = taskString(key: "99")
                talkNode.isHidden = false
                npcArray[tag-1].dailyTask = 0
                npcArray[tag-1].will += 15
                taskNodeArr[4].isHidden = true
                HnsTask.goodDic["food"] = food - 10
                ifFinishTask()
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
    func textHidden() -> Bool
    {
        if self.textBackground.isHidden == false
        {
            textNode[0].text = ""
            textNode[1].text = ""
            textNode[2].text = ""
            self.textBackground.isHidden = true
            return true
        }
        return false
    }
}

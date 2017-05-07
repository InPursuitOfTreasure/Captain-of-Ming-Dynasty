//
//  HnsMapScene.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 16/9/13.
//  Copyright © 2016年 hns. All rights reserved.
//

import SpriteKit

let texture1 = SKTexture.init(imageNamed: "captain1")
let texture2 = SKTexture.init(imageNamed: "captain2")
let texture3 = SKTexture.init(imageNamed: "captain3")
let texture4 = SKTexture.init(imageNamed: "captain4")

class HnsMapScene : SKScene, SKPhysicsContactDelegate
{
    //the note, never run
    func annotation()
    {
        //SKUtil.m: MGGetBoolAnswer is not available in the simulator.
        //the concole will fill up with these messages.
        //https://forums.developer.apple.com/thread/62983
        //the apple staff member said:"This is a harmless message. It will be removed in the next release. Sorry for the confusion."
        
        //in swift, a variable need a default value. Or there is a worning: Class has no initializers. Use ? to solve it
        
        //the map is 4 multiplier, so, the biggest point is (-368*8, -207*8)
        
        //mutating method sent to immutable object, let or var
    }
    
    static let mapScene = HnsMapScene.init()
    
    //func update need a defaulf value, so give value (368, 207), it is center
    var touchLocation: CGPoint = CGPoint(x: 368, y: 207)
    
    //map
    var mapNode = SKSpriteNode.init(imageNamed: "map.jpg")
    
    //captain
    //long long after, maybe use textureSets to do the gif
    var meNode = SKSpriteNode.init(texture: texture1)
    
    //alert
    var alertNode = SKSpriteNode.init(imageNamed: "alert")
    var alertText = SKLabelNode(fontNamed:"STKaiti")
    var alertOk = SKSpriteNode.init(imageNamed: "alertok")
    var alertCancel = SKSpriteNode.init(imageNamed: "alertCancel")
    
    var textNode: Array<SKLabelNode> = [
        SKLabelNode(fontNamed:"STKaiti"),
        SKLabelNode(fontNamed:"STKaiti"),
        SKLabelNode(fontNamed:"STKaiti"),
        ]
    var textBackground = SKSpriteNode.init(imageNamed: "textBackground")
    
    var riverNode: Array<SKSpriteNode> = [
                    HnsRiver().initWithSize(width: 616, height: 80),
                    HnsRiver().initWithSize(width: 600, height: 80),
                    HnsRiver().initWithSize(width: 470, height: 80),
                    HnsRiver().initWithSize(width:  84, height: 272),
                    HnsRiver().initWithSize(width:  84, height: 333),
                    HnsRiver().initWithSize(width: 470, height: 70),
                    HnsRiver().initWithSize(width: 600, height: 70),
                    HnsRiver().initWithSize(width: 616, height: 70),
                    ]
    var houseNode: Array<HnsHouseNode> = [
        HnsHouse().initWithSize(width: 330, height: 270, type: "5", zPosition: -1, tag: 8),
        HnsHouse().initWithSize(width: 320, height: 210, type: "4", zPosition: -1, tag: 6),
        HnsHouse().initWithSize(width: 320, height: 210, type: "2", zPosition: -1, tag: 5),
        HnsHouse().initWithSize(width: 320, height: 210, type: "8", zPosition: 200, tag: 7),
        HnsHouse().initWithSize(width: 270, height: 210, type: "1", zPosition: -1, tag: 1),
        HnsHouse().initWithSize(width: 270, height: 210, type: "1", zPosition: 200, tag: 2),
        HnsHouse().initWithSize(width: 270, height: 210, type: "1", zPosition: -1, tag: 3),
        HnsHouse().initWithSize(width: 270, height: 210, type: "1", zPosition: 200, tag: 4),
        ]
    //direction
    //when game begans, captain don't move, so give value 0
    //when scene change and go back, also need value 0, this quesition is not solved until now, recorded on 2016.12.25, marry Charismas.
    var direction: Int = 0
    var oldDirection: Int = 0
    var backDirection: Int = 0
    
    //handle, many functions to process the data
    var hnsHandle: HnsMapHandle = HnsMapHandle()
    
    //timer to handle timeDic
    var timer: Timer?
    
    var contactTag: Int = -1
    
    func addTimer()
    {
        if (timer == nil)
        {
            timer = Timer.init(timeInterval: 2, target: self, selector: #selector(handleTimeDic), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        }
    }
    
    func alertHidden(hidden: Bool)
    {
        self.alertNode.isHidden = hidden
        self.alertText.isHidden = hidden
        self.alertOk.isHidden = hidden
        self.alertCancel.isHidden = hidden
    }
    
    func clickCancel()
    {
        if contactTag == 9
        {
            backDirection = 0
            direction = 0
            oldDirection = 0
        }
        addTimer()
        contactTag = -1
        alertHidden(hidden: true)
    }
    
    func clickOk()
    {
        if contactTag == 0
        {
            backDirection = 0
            direction = 0
            oldDirection = 0
            
            presentIntroScence(tag: 8)
            die()
        }
        else if contactTag <= 7
        {
            presentInnerScence(tag: contactTag)
        }
        else if contactTag == 8
        {
            let iron = HnsTask.goodDic["iron"]! as Int
            HnsTask.goodDic["iron"] = iron + 1
            let silver = HnsTask.goodDic["silver"]! as Int
            let r = arc4random() % 20
            if r == 1
            {
                HnsTask.goodDic["silver"] = silver + 1
            }
            handleTimeDic()
            addTimer()
        }
        else if contactTag == 9
        {
            let wood = HnsTask.goodDic["wood"]! as Int
            HnsTask.goodDic["wood"] = wood + 1
            handleTimeDic()
            backDirection = 0
            direction = 0
            oldDirection = 0
            addTimer()
        }
        contactTag = -1
        alertHidden(hidden: true)
    }
    
    func contactWithID(contactTag: Int)
    {
        backDirection = -direction
        direction = 0
        oldDirection = 0
        
        alertText.text = hnsHandle.getAlertText(textID: contactTag)
        let x = alertText.frame.size.width
        let y = alertText.frame.size.height
        alertText.position = CGPoint.init(x: 50 + x/2, y: 120+y/2)
        alertHidden(hidden: false)
        
        removeTimer()
    }
    
    func createAlert()
    {
        DispatchQueue(label: "com.hns.alertQueue").async
            {
                let x = self.frame.midX
                var y = 300
                
                self.alertNode.size = CGSize(width: self.frame.width, height: 200)
                self.alertNode.position = CGPoint(x: x, y: 100)
                self.alertNode.zPosition = 1002
                
                self.alertText.fontSize = 24
                self.alertText.fontColor = SKColor.black
                self.alertText.zPosition = 1003
                
                for i in 0 ... self.textNode.count - 1
                {
                    self.textNode[i].fontSize = 24
                    self.textNode[i].fontColor = SKColor.black
                    self.textNode[i].position = CGPoint(x: x + 70, y: CGFloat(y))
                    self.textNode[i].zPosition = 1004
                    y -= 40
                }
                self.textBackground.size = CGSize(width: 420, height: 150)
                self.textBackground.position = CGPoint(x: x + 70, y: 270)
                self.textBackground.zPosition = 1000
                self.textBackground.isHidden = true
                
                self.alertOk.size = CGSize(width: 100, height: 40)
                self.alertOk.position = CGPoint(x: x - 120, y: 50)
                self.alertOk.zPosition = 1003
                self.alertOk.name = "ok"
                
                self.alertCancel.size = CGSize(width: 100, height: 40)
                self.alertCancel.position = CGPoint(x: x + 120, y: 50)
                self.alertCancel.zPosition = 1003
                self.alertCancel.name = "cancel"
                
                self.alertHidden(hidden: true)
                
                DispatchQueue.main.async
                    {
                        self.addChild(self.alertNode)
                        self.addChild(self.alertText)
                        self.addChild(self.alertOk)
                        self.addChild(self.alertCancel)
                        
                        for i in 0 ... self.textNode.count - 1
                        {
                            self.addChild(self.textNode[i])
                        }
                        self.addChild(self.textBackground)
                }
        }
    }
    
    func createMapNode()
    {
        DispatchQueue(label: "com.hns.mapQueue").async
            {
                self.mapNode.anchorPoint = CGPoint.zero
                self.mapNode.size = CGSize(width: self.size.width*4, height: self.size.height*4)
                self.mapNode.position = self.hnsHandle.getPosition()
                self.mapNode.zPosition = -100
                
                self.hnsHandle.updateRiver(riverArray: self.riverNode)
                self.hnsHandle.updateHouse(houseArray: self.houseNode)
                
                DispatchQueue.main.async
                    {
                        self.physicsWorld.contactDelegate = self
                        self.physicsWorld.gravity = CGVector.init(dx: 0, dy: 0)
                        for i in 0 ... self.riverNode.count-1
                        {
                            self.addChild(self.riverNode[i])
                        }
                        for i in 0 ... self.houseNode.count-1
                        {
                            self.addChild(self.houseNode[i])
                        }
                        self.addChild(self.mapNode)
                }
        }
    }
    
    func createMeNode()
    {
        DispatchQueue(label: "com.hns.meQueue").async
            {
                self.meNode.size = CGSize(width: 100, height: 100)
                self.meNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                self.meNode.physicsBody = SKPhysicsBody.init(rectangleOf: self.meNode.frame.size)
                self.meNode.physicsBody?.categoryBitMask = HnsBitMaskType.me
                self.meNode.physicsBody?.contactTestBitMask = HnsBitMaskType.house
                self.meNode.physicsBody?.allowsRotation = false
                self.meNode.physicsBody?.affectedByGravity = false
                self.meNode.zPosition = 150
                
                DispatchQueue.main.async
                    {
                        self.addChild(self.meNode)
                }
        }
    }
    
    func createTimeLabel()
    {
        DispatchQueue(label: "com.hns.timeLabelQueue").async
            {
                HnsTimeLabel().initTimeLabel(width: Int(self.frame.width))
                HnsTimeLabel.timeLabel.zPosition = 1000
                HnsTimeLabel.timeText .zPosition = 1001
                
                DispatchQueue.main.async
                    {
                        self.addChild(HnsTimeLabel.timeLabel)
                        self.addChild(HnsTimeLabel.timeText)
                }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if  contact.bodyA.categoryBitMask == HnsBitMaskType.river
            ||
            contact.bodyB.categoryBitMask == HnsBitMaskType.river
        {
            contactTag = 0
            contactWithID(contactTag: contactTag)
        }
        if  contact.bodyA.categoryBitMask == HnsBitMaskType.house
            ||
            contact.bodyB.categoryBitMask == HnsBitMaskType.house
        {
            let node: HnsHouseNode
            if contact.bodyA.categoryBitMask == HnsBitMaskType.house {
                node = contact.bodyA.node as! HnsHouseNode
            } else {
                node = contact.bodyB.node as! HnsHouseNode
            }
            contactTag = node.tag
            contactWithID(contactTag: contactTag)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact)
    {
        backDirection = 0
        direction = 0
        oldDirection = 0
        self.meNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
    }

    override func didMove(to view: SKView)
    {
        mapNode.position = hnsHandle.getPosition()
        HnsTimeLabel().updateTimeLabel()
        addTimer()
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.view?.addGestureRecognizer(longpress)
    }
    
    func handleTimeDic()
    {
        hnsHandle.updateTimeDic()
        HnsTimeLabel().updateTimeLabel()
    }
    
    func longPress() {
        var x: CGFloat = touchLocation.x
        var y: CGFloat = touchLocation.y
        x -= 368
        y -= 207
        //long press center of screen, save and exit.
        if (abs(x) < 30)&&(abs(y) < 30)
        {
            let food = HnsTask.goodDic["food"]! as Int
            let silver = HnsTask.goodDic["silver"]! as Int
            let iron = HnsTask.goodDic["iron"]! as Int
            let wood = HnsTask.goodDic["wood"]! as Int
            let type = HnsTask.task.type as Int
            
            textNode[0].text = "粮食  " + String(food) + "  银子  " + String(silver)
            textNode[1].text = "铁矿  " + String(iron) + "  木材  " + String(wood)
            textNode[2].text = "任务提示  " + HnsTask.task.affectPeople(type: type)
            self.textBackground.isHidden = false
        }
        removeTimer()
    }
    
    func presentInnerScence(tag: Int)
    {
        hnsHandle.save()
        HnsInnerScene.innerScene.tag = tag
        
        HnsIntroScene.introScene.nextScene = HnsInnerScene.innerScene
        HnsIntroScene.introScene.tag = tag
        
        let doors = SKTransition.fade(withDuration: 0.7)
        self.view?.presentScene(HnsIntroScene.introScene, transition: doors)
    }
    
    func presentIntroScence(tag: Int)
    {
        let doors = SKTransition.fade(withDuration: 0.7)
        HnsIntroScene.introScene.nextScene = GameScene.init()
        HnsIntroScene.introScene.tag = tag
        self.view?.presentScene(HnsIntroScene.introScene, transition: doors)
    }
    
    func removeTimer()
    {
        timer?.invalidate()
        timer = nil
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
    
    //when touchs calculate the direction, to move.
    //judge if there is a npc, or if there needs a click event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if textHidden()
        {
            addTimer()
            return
        }
        
        let hnsTouches = touches as NSSet
        let touch = hnsTouches.anyObject() as! UITouch
        touchLocation = touch.location(in: self)
        let node = atPoint(touchLocation) as? SKSpriteNode
        
        if node?.name == "cancel"
        {
            clickCancel()
            return
        }
        if node?.name == "ok"
        {
            clickOk()
            return
        }
        
        if alertNode.isHidden
        {
            direction = hnsHandle.calculateDirection(location: touchLocation)
        }
//        else
//        {
//            clickCancel()
//            alertHidden(hidden: true)
//        }
    }

    override func update(_ currentTime: TimeInterval)
    {
        updateMapNode(direction: self.direction)
        hnsHandle.updateRiver(riverArray: self.riverNode)
        hnsHandle.updateHouse(houseArray: self.houseNode)
    }
    
    func updateMapNode(direction: Int)
    {
        if backDirection != 0
        {
            if direction != backDirection && direction != 0
            {
                return
            }
        }
        if contactTag > -1
        {
            return
        }
        var x: CGFloat = mapNode.position.x
        var y: CGFloat = mapNode.position.y
        switch direction
        {
        case 1:
            if x > -2192
            {
                x -= 16
            }
            if (oldDirection != direction)
            {
                oldDirection = direction
                meNode.texture = texture1
            }
        case -1:
            if x < -256
            {
                x += 16
            }
            else
            {
                contactTag = 9
                contactWithID(contactTag: contactTag)
            }
            if (oldDirection != direction)
            {
                oldDirection = direction
                meNode.texture = texture2
            }
        case 3:
            if y > -1212
            {
                y -= 9
            }
            if (oldDirection != direction)
            {
                oldDirection = direction
                meNode.texture = texture3
            }
        case -3:
            if y < -81
            {
                y += 9
            }
            if (oldDirection != direction)
            {
                oldDirection = direction
                meNode.texture = texture4
            }
        default:
            if backDirection != 0
            {
                self.direction = backDirection
                oldDirection = backDirection
            }
        }
        hnsHandle.position = CGPoint(x: x, y: y)
        mapNode.position = hnsHandle.getPosition()
    }
}

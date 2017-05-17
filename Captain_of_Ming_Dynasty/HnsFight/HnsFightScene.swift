//
//  HnsFightScene.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/5/15.
//  Copyright © 2017年 hns. All rights reserved.
//

import Foundation
import SpriteKit

let waitStrArr = ["down0.png", "up0.png", "left0.png", "attacked.png", "die.png"]

let walkDownStrArr = ["down0.png", "down1.png", "down2.png"]
let walkUpStrArr = ["up0.png", "up1.png", "up2.png"]
let walkLeftStrArr = ["left0.png", "left1.png", "left2.png"]

let attackDownStrArr = ["attack_down0.png", "attack_down1.png", "attack_down2.png"]
let attackUpStrArr = ["attack_up0.png", "attack_up1.png", "attack_up2.png"]
let attackLeftStrArr = ["attack_left0.png", "attack_left1.png", "attack_left2.png"]

let defenceStrArr = ["defence_down.png", "defence_up.png", "defence_left.png"]

let positionArray = [CGPoint.init(x: 500, y: 200),
                     CGPoint.init(x: 200, y: 200),
                     CGPoint.init(x: 200, y: 300),
                     CGPoint.init(x: 200, y: 100),
                     CGPoint.init(x: 120, y: 200),
                     CGPoint.init(x: 120, y: 300),
                     CGPoint.init(x: 120, y: 100),
                     CGPoint.init(x: 40, y: 200),]

class HnsFightScene: SKScene, SKPhysicsContactDelegate
{
    let fightHandle: HnsFightHandle = HnsFightHandle()
    let backgroundNode = SKSpriteNode.init(imageNamed: "fightMap")
    let startPosition = CGPoint.init(x: 460, y: 360)
    let endPosition = CGPoint.init(x: 700, y: 360)
    
    let startFight = SKSpriteNode.init(imageNamed: "btn_start_n")
    var routeArray: Array<SKSpriteNode> = []
    let routeNode = SKSpriteNode.init(imageNamed: "route")
    let arriveNode = SKSpriteNode.init(imageNamed: "roundrect")
    let firstPosition = CGPoint.init(x: 640, y: 200)
    var clickName: String = ""
    
    var captionUnit: HnsFightUnit? = nil
    var captionHead: HnsFightHead? = nil
    var npcUnitArr: Array<HnsFightUnit>? = nil
    var npcHeadArr: Array<HnsFightHead>? = nil
    
    var timer: Timer?
    var direction: Int = 0
    var chooseItem: Int = -1
    
    let capWaitArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "cap", strArray: waitStrArr)
    let npcWaitArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "npc", strArray: waitStrArr)
    
    let capWalkDownArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "cap", strArray: walkDownStrArr)
    let npcWalkDownArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "npc", strArray: walkDownStrArr)
    let capWalkUpArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "cap", strArray: walkUpStrArr)
    let npcWalkUpArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "npc", strArray: walkUpStrArr)
    let capWalkLeftArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "cap", strArray: walkLeftStrArr)
    let npcWalkLeftArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "npc", strArray: walkLeftStrArr)
    
    let capAttackDownArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "cap", strArray: attackDownStrArr)
    let npcAttackDownArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "npc", strArray: attackDownStrArr)
    let capAttackUpArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "cap", strArray: attackUpStrArr)
    let npcAttackUpArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "npc", strArray: attackUpStrArr)
    let capAttackLeftArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "cap", strArray: attackLeftStrArr)
    let npcAttackLeftArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "npc", strArray: attackLeftStrArr)
    
    let capDefenceArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "cap", strArray: defenceStrArr)
    let npcDefenceArray: Array<SKTexture> = HnsFightHandle().getTextureArray(type: "npc", strArray: defenceStrArr)
    
    func addTimer()
    {
        if (timer == nil)
        {
            timer = Timer.init(timeInterval: 0.04, target: self, selector: #selector(handleHead), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        }
    }
    func addDieTimer()
    {
        if (timer == nil)
        {
            timer = Timer.init(timeInterval: 0.5, target: self, selector: #selector(killed), userInfo: nil, repeats: false)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        }
    }
    func addKillTimer()
    {
        let t = Timer.init(timeInterval: 0.5, target: self, selector: #selector(killNpc), userInfo: nil, repeats: false)
            RunLoop.main.add(t, forMode: RunLoopMode.commonModes)
    }
    
    func attackAction(attack: HnsFightUnit, attacked: HnsFightUnit, tag: Int)
    {
        if attack.node?.tag == 0
        {
            attack.node?.run(attackActionGroup(tag: tag + 10, unit: attack))
        }
        else
        {
            attack.node?.run(attackActionGroup(tag: tag, unit: attack))
        }
        let result = Int(arc4random() % 10)
        let reduce = ((attack.data?.attack)! + 3) * 4 - (attacked.data?.defence)!
        if attack.data?.isArmed == true
        {
            if result > 2
            {
                attacked.node?.run(attackedActionGroup(reduce: reduce, unit: attacked))
            }
            else
            {
                attacked.node?.run(defenceActionGroup(unit: attacked))
            }
        }
        else if attacked.data?.isArmour == true
        {
            if result > 6
            {
                attacked.node?.run(attackedActionGroup(reduce: reduce, unit: attacked))
            }
            else
            {
                attacked.node?.run(defenceActionGroup(unit: attacked))
            }
        }
        else if result < 5
        {
            attacked.node?.run(attackedActionGroup(reduce: reduce, unit: attacked))
        }
        else
        {
            attacked.node?.run(defenceActionGroup(unit: attacked))
        }
    }
    func attackActionGroup(tag: Int, unit: HnsFightUnit) -> SKAction
    {
        let action0 = back(unit: unit)
        let action1 = SKAction.animate(with: attackTextureArr(tag: tag), timePerFrame: 0.1)
        let action2 = SKAction.run {
            if tag == 4 || tag == 14
            {
                unit.node?.xScale = -1
            }
            else
            {
                unit.node?.xScale = 1
            }
        }
        let group1 = SKAction.group([action1, action2])
        let group2 = SKAction.sequence(walkActions(points: [(unit.node?.position)!, positionArray[unit.tag]], unit: unit))
        return SKAction.sequence([action0, group1, group2])
    }
    func attackedActionGroup(reduce: Int, unit: HnsFightUnit) -> SKAction
    {
        unit.data?.hp = (unit.data?.hp)! - reduce
        let action0 = SKAction.wait(forDuration: 0.2)
        let action1 = SKAction.run {

            if (unit.data?.hp)! < 0
            {
                unit.data?.hp = 0
            }
            unit.hp?.size = CGSize.init(width: (unit.data?.hp)!/2, height: 10)
            if unit.tag > 0
            {
                unit.node?.texture = self.npcWaitArray[3]
            }
            else
            {
                unit.node?.texture = self.capWaitArray[3]
            }
        }
        let action2 = SKAction.wait(forDuration: 0.1)
        let action3 = SKAction.run {
            
            if unit.tag > 0
            {
                if (unit.data?.hp)! > 0
                {
                    if self.direction == 4 || self.direction == 3
                    {
                        unit.node?.texture = self.npcWaitArray[2]
                    }
                    else
                    {
                        unit.node?.texture = self.npcWaitArray[2-self.direction]
                    }
                }
                else
                {
                    unit.node?.texture = self.npcWaitArray[4]
                    self.addKillTimer()
                }
            }
            else
            {
                if (unit.data?.hp)! > 0
                {
                    if self.direction == 4 || self.direction == 3
                    {
                        unit.node?.texture = self.capWaitArray[2]
                    }
                    else
                    {
                        unit.node?.texture = self.capWaitArray[2-self.direction]
                    }
                }
                else
                {
                    unit.node?.texture = self.capWaitArray[4]
                    self.removeTimer()
                    self.addDieTimer()
                }
            }
        }
        if (unit.data?.hp)! > 0
        {
            let group = SKAction.sequence(walkActions(points: [(unit.node?.position)!, positionArray[unit.tag]], unit: unit))
            return SKAction.sequence([action0, action1, action2, action3, group])
        }
        return SKAction.sequence([action0, action1, action2, action3])
    }
    func attackDirection(attack: HnsFightUnit, attacked: HnsFightUnit)
    {
        let x = (attack.node?.position.x)! - (attacked.node?.position.x)!
        let y = (attack.node?.position.y)! - (attacked.node?.position.y)!
        if abs(x) > abs(y)
        {
            if x > 0
            {
                direction = 3
            }
            else
            {
                direction = 4
            }
        }
        else if y > 0
        {
            direction = 1
        }
        else
        {
            direction = 2
        }
    }
    
    func attackTextureArr(tag: Int) -> Array<SKTexture>
    {
        switch tag {
        case 1:
            return npcAttackDownArray
        case 2:
            return npcAttackUpArray
        case 3:
            return npcAttackLeftArray
        case 4:
            return npcAttackLeftArray
        case 11:
            return capAttackLeftArray
        case 12:
            return capAttackLeftArray
        default:
            return capAttackLeftArray
        }
    }
    
    func back(unit: HnsFightUnit) -> SKAction
    {
        let x = unit.node?.position.x
        let y = unit.node?.position.y
        switch direction {
        case 1:
            return SKAction.move(to: CGPoint.init(x: x!, y: y!+20), duration: 0.1)
        case 2:
            return SKAction.move(to: CGPoint.init(x: x!, y: y!-20), duration: 0.1)
        case 3:
            return SKAction.move(to: CGPoint.init(x: x!+20, y: y!), duration: 0.1)
        default:
            return SKAction.move(to: CGPoint.init(x: x!-20, y: y!), duration: 0.1)
        }
    }
    
    func clickNodeBegin(tag: Int)
    {
        if tag == 0
        {
            captionUnit?.chooseFrame?.isHidden = false
            captionHead?.head?.colorBlendFactor = 0.5
        }
        else
        {
            npcUnitArr?[tag - 1].chooseFrame?.isHidden = false
            npcHeadArr?[tag - 1].head?.colorBlendFactor = 0.5
        }
        chooseItem = tag
    }
    func clickNodeEnd()
    {
        if chooseItem == 0
        {
            captionUnit?.chooseFrame?.isHidden = true
            captionHead?.head?.colorBlendFactor = 0
        }
        else
        {
            npcUnitArr?[chooseItem - 1].chooseFrame?.isHidden = true
            npcHeadArr?[chooseItem - 1].head?.colorBlendFactor = 0
        }
        chooseItem = -1
    }
    
    func clickStartFightBegin()
    {
        startFight.colorBlendFactor = 0.5
        routeNode.colorBlendFactor = 0.5
        arriveNode.colorBlendFactor = 0.5
    }
    func clickStartFightEnd()
    {
        startFight.colorBlendFactor = 0
        routeNode.colorBlendFactor = 0
        arriveNode.colorBlendFactor = 0
        captionUnit?.data?.isWalk = true
        captionHead?.head?.position = startPosition
        if routeArray.count > 0
        {
            var arr: Array<CGPoint> = [(captionUnit!.node?.position)!]
            for item in routeArray
            {
                arr.append(item.position)
                item.removeFromParent()
            }
            arr.append((captionUnit!.node?.position)!)
            routeArray.removeAll()
            moveAction(unit: captionUnit!, points: arr)
        }
        else
        {
            captionUnit?.data?.isWalk = false
        }
        ifHiddenSetRoute(flag: true)
        addTimer()
    }
    
    func clickRouteBegin()
    {
        arriveNode.colorBlendFactor = 0.5
    }
    func clickRouteEnd()
    {
        arriveNode.colorBlendFactor = 0
        
        let node = SKSpriteNode.init(imageNamed: "route")
        node.position = routeNode.position
        node.size = CGSize.init(width: 40, height: 30)
        node.name = "route"
        routeArray.append(node)
        self.addChild(node)
        
        routeNode.position = firstPosition
    }
    
    func createBackground()
    {
        backgroundNode.anchorPoint = CGPoint.init(x: 0, y: 0)
        backgroundNode.zPosition = -2
        backgroundNode.size = self.size
        backgroundNode.position = CGPoint.init(x: 0, y: 0)
        self.addChild(backgroundNode)
    }
    func creatProgress()
    {
        let progress = SKSpriteNode.init(imageNamed: "progress")
        progress.size = CGSize.init(width: 300, height: 30)
        progress.position = CGPoint.init(x: 580, y: 360)
        progress.zPosition = -1
        self.addChild(progress)
        
        for head in npcHeadArr!
        {
            head.head?.position = startPosition
            head.head?.zPosition = 10
            self.addChild(head.head!)
        }
        
        captionHead?.head?.position = startPosition
        captionHead?.head?.zPosition = 11
        self.addChild((captionHead?.head)!)
    }
    func createSetRoute()
    {
        startFight.position = CGPoint.init(x: 640, y: 170)
        startFight.size = CGSize.init(width: 80, height: 50)
        startFight.name = "startFight"
        startFight.color = .darkGray
        startFight.isHidden = true
        self.addChild(startFight)
        routeNode.position = firstPosition
        routeNode.size = CGSize.init(width: 40, height: 30)
        routeNode.name = "routeNode"
        routeNode.color = .darkGray
        routeNode.isHidden = true
        self.addChild(routeNode)
        arriveNode.position = firstPosition
        arriveNode.size = CGSize.init(width: 50, height: 50)
        arriveNode.name = "routeNode"
        arriveNode.color = .darkGray
        arriveNode.isHidden = true
        self.addChild(arriveNode)
    }
    func createUnit()
    {
        //down , up , left
        fightHandle.createUnit(unit: captionUnit!, position: positionArray[(captionUnit?.tag)!])
        captionUnit?.node?.physicsBody = SKPhysicsBody.init(rectangleOf: (captionUnit?.node?.size)!, center: CGPoint.init(x: 0.5, y: 0.5))
        captionUnit?.node?.physicsBody?.categoryBitMask = HnsBitMaskType.cap
        captionUnit?.node?.physicsBody?.contactTestBitMask = HnsBitMaskType.npc
        captionUnit?.node?.physicsBody?.isDynamic = false
        captionUnit?.node?.texture = capWaitArray[2]
        
        captionUnit?.data?.direction = 3
        self.addChild((captionUnit?.chooseFrame)!)
        self.addChild((captionUnit?.node)!)
        self.addChild((captionUnit?.hp)!)
        
        for unit in npcUnitArr!
        {
            fightHandle.createUnit(unit: unit, position: positionArray[(unit.tag)])
            unit.node?.texture = npcWaitArray[2]
            unit.node?.xScale = -1
            unit.data?.direction = 4
            unit.node?.physicsBody = SKPhysicsBody.init(rectangleOf: (unit.node?.size)!, center: CGPoint.init(x: 0.5, y: 0.5))
            unit.node?.physicsBody?.categoryBitMask = HnsBitMaskType.npc
            unit.node?.physicsBody?.collisionBitMask = HnsBitMaskType.cap
            unit.node?.physicsBody?.allowsRotation = false
            self.addChild((unit.chooseFrame)!)
            self.addChild((unit.node)!)
            self.addChild((unit.hp)!)
        }
    }
    
    func defenceActionGroup(unit: HnsFightUnit) -> SKAction
    {
        let action0 = SKAction.wait(forDuration: 0.1)
        let action1 = SKAction.run {
            
            if unit.tag > 0
            {
                if self.direction == 4 || self.direction == 3
                {
                    unit.node?.texture = self.npcDefenceArray[2]
                }
                else
                {
                    unit.node?.texture = self.npcDefenceArray[2-self.direction]
                }
            }
            else
            {
                if self.direction == 4 || self.direction == 3
                {
                    unit.node?.texture = self.capDefenceArray[2]
                }
                else
                {
                    unit.node?.texture = self.capDefenceArray[2-self.direction]
                }
            }
        }
        let action2 = SKAction.wait(forDuration: 0.2)
        let action3 = SKAction.run {
            
            if unit.tag > 0
            {
                if self.direction == 4 || self.direction == 3
                {
                    unit.node?.texture = self.npcWaitArray[2]
                }
                else
                {
                    unit.node?.texture = self.npcWaitArray[2-self.direction]
                }
            }
            else
            {
                if self.direction == 4 || self.direction == 3
                {
                    unit.node?.texture = self.capWaitArray[2]
                }
                else
                {
                    unit.node?.texture = self.capWaitArray[2-self.direction]
                }
            }
        }
        let group = SKAction.sequence(walkActions(points: [(unit.node?.position)!, positionArray[unit.tag]], unit: unit))
        return SKAction.sequence([action0, action1, action2, action3, group])
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        //print(cap.tag) prove cap is caption
        let cap = contact.bodyA.node as! HnsFightNode
        let npc = contact.bodyB.node as! HnsFightNode
        cap.removeAllActions()
        npc.removeAllActions()
        if captionUnit?.data?.isWalk == true
        {
            if npcUnitArr?[npc.tag - 1].data?.isWalk == true && arc4random() % 2 == 1
            {
                attackDirection(attack: (npcUnitArr?[npc.tag - 1])!, attacked: captionUnit!)
                attackAction(attack: (npcUnitArr?[npc.tag - 1])!, attacked: captionUnit!, tag: direction)
            }
            else
            {
                attackDirection(attack: captionUnit!, attacked: (npcUnitArr?[npc.tag - 1])!)
                attackAction(attack: captionUnit!, attacked: (npcUnitArr?[npc.tag - 1])!, tag: direction)
            }
        }
        else
        {
            attackDirection(attack: (npcUnitArr?[npc.tag - 1])!, attacked: captionUnit!)
            attackAction(attack: (npcUnitArr?[npc.tag - 1])!, attacked: captionUnit!, tag: direction)
        }
    }

    override func didMove(to view: SKView)
    {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector.init(dx: 0, dy: 0)
        createBackground()
        creatProgress()
        createSetRoute()
        createUnit()
        addTimer()
    }
    
    func handleHead()
    {
        var position: CGPoint = (captionHead?.head?.position)!
        if captionUnit?.data?.isWalk == false
        {
            captionHead?.head?.position = CGPoint.init(x: position.x + CGFloat((captionUnit?.data?.speed)!), y: position.y)
        }
        for head in npcHeadArr!
        {
            let data = npcUnitArr?[head.tag - 1].data
            if (data?.isWalk)!
            {
                continue
            }
            position = (head.head?.position)!
            head.head?.position = CGPoint.init(x: position.x + CGFloat((data?.speed)!), y: position.y)
            if (head.head?.position.x)! >= endPosition.x
            {
                head.head?.position = startPosition
                npcUnitArr?[head.tag - 1].data?.isWalk = true
                moveAction(unit: (npcUnitArr?[head.tag - 1])!,
                           points: [positionArray[head.tag],
                                    positionArray[0],
                                    positionArray[head.tag]])
            }
        }
        if (captionHead?.head?.position.x)! >= endPosition.x
        {
            ifHiddenSetRoute(flag: false)
            removeTimer()
        }
    }
    func ifHiddenSetRoute(flag: Bool)
    {
        startFight.isHidden = flag
        routeNode.isHidden = flag
        arriveNode.isHidden = flag
    }
    func killed()
    {
        let doors = SKTransition.fade(withDuration: 0.7)
        HnsIntroScene.introScene.nextScene = GameScene()
        HnsIntroScene.introScene.tag = 14
        self.view?.presentScene(HnsIntroScene.introScene, transition: doors)
        die()
    }
    func killNpc()
    {
        var tag = 0
        for unit in npcUnitArr!
        {
            if (unit.data?.hp)! <= 0
            {
                tag = unit.tag
                npcHeadArr?[tag - 1].head?.removeFromParent()
                npcHeadArr?.remove(at: tag - 1)
                npcUnitArr?[tag - 1].chooseFrame?.removeFromParent()
                npcUnitArr?[tag - 1].hp?.removeFromParent()
                npcUnitArr?[tag - 1].node?.removeFromParent()
                npcUnitArr?.remove(at: tag - 1)
            }
        }
        if (npcHeadArr?.count)! <= 0
        {
            removeTimer()
            killed()
            return
        }
        for i in 0...(npcUnitArr?.count)! - 1
        {
            npcHeadArr?[i].head?.tag = i + 1
            npcHeadArr?[i].tag = i + 1
            npcUnitArr?[i].node?.tag = i + 1
            npcUnitArr?[i].tag = i + 1
        }
    }
    func moveAction(unit: HnsFightUnit, points: Array<CGPoint>)
    {
        unit.node?.run(SKAction.sequence(walkActions(points: points, unit: unit)))
    }
    func moveActions(points: Array<CGPoint>) -> Array<SKAction>
    {
        var arr: Array<SKAction> = []
        var point1: CGPoint
        var point2: CGPoint
        for i in 1...points.count - 1
        {
            point1 = points[i-1]
            point2 = points[i]
            if point1.x != point2.x
            {
                if point1.x > point2.x
                {
                    arr.append(SKAction.move(to: CGPoint.init(x: point2.x, y: point1.y), duration: TimeInterval(point1.x - point2.x)*3/400))
                }
                else
                {
                    arr.append(SKAction.move(to: CGPoint.init(x: point2.x, y: point1.y), duration: TimeInterval(point2.x - point1.x)*3/400))
                }
            }
            if point1.y != point2.y
            {
                if point1.y > point2.y
                {
                    arr.append(SKAction.move(to: CGPoint.init(x: point2.x, y: point2.y), duration: TimeInterval(point1.y - point2.y)*3/400))
                }
                else
                {
                    arr.append(SKAction.move(to: CGPoint.init(x: point2.x, y: point2.y), duration: TimeInterval(point2.y - point1.y)*3/400))
                }
            }
        }
        return arr
    }
    func removeTimer()
    {
        if (timer != nil)
        {
            timer?.invalidate()
            timer = nil
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let hnsTouches = touches as NSSet
        let touch = hnsTouches.anyObject() as! UITouch
        let node = atPoint(touch.location(in: self)) as? SKSpriteNode
        let unitNode = atPoint(touch.location(in: self)) as? HnsFightNode
        
        if unitNode?.name == "unitOrHead"
        {
            clickNodeBegin(tag: (unitNode?.tag)!)
            return
        }
        if node?.name == "startFight"
        {
            clickStartFightBegin()
            clickName = "startFight"
        }
        if node?.name == "routeNode"
        {
            clickRouteBegin()
            clickName = "routeNode"
        }
        if node?.name == "route"
        {
            var i = 0
            while i < routeArray.count
            {
                if routeArray[i].position == node?.position
                {
                    node?.removeFromParent()
                    routeArray.remove(at: i)
                }
                i += 1
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let hnsTouches = touches as NSSet
        let touch = hnsTouches.anyObject() as! UITouch
        if clickName == "routeNode"
        {
            routeNode.position = touch.location(in: self)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if chooseItem > -1
        {
            clickNodeEnd()
        }
        if clickName == "startFight"
        {
            clickStartFightEnd()
        }
        if clickName == "routeNode"
        {
            clickRouteEnd()
        }
        clickName = ""
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        var position = (captionUnit?.node?.position)!
        captionUnit?.chooseFrame?.position = position
        captionUnit?.hp?.position = CGPoint(x: position.x-25, y: position.y + 30)
        for unit in npcUnitArr!
        {
            position = (unit.node?.position)!
            unit.chooseFrame?.position = position
            unit.hp?.position = CGPoint(x: position.x-25, y: position.y + 30)
        }
    }
    
    func walkAction(time: TimeInterval, moveTo: CGPoint, direction: Int, unit: HnsFightUnit) -> SKAction
    {
        var arr = walkTextureArr(dir: direction)
        if unit.tag == 0
        {
            arr = walkTextureArr(dir: direction + 10)
        }
        let action1 = SKAction.repeat(SKAction.animate(with: arr, timePerFrame: 0.25), count: Int(time / 0.75))
        let action2 = SKAction.move(to: moveTo, duration: time)
        var action3: SKAction?
        if direction == 4
        {
            action3 = SKAction.run {
                unit.node?.xScale = -1
            }
        }
        else
        {
            action3 = SKAction.run {
                unit.node?.xScale = 1
            }
        }
        return SKAction.group([action1, action2, action3!])
    }
    func walkActions(points: Array<CGPoint>, unit: HnsFightUnit) -> Array<SKAction>
    {
        var arr: Array<SKAction> = []
        var point1: CGPoint
        var point2: CGPoint
        for i in 1...points.count - 1
        {
            point1 = points[i-1]
            point2 = points[i]
            if point1.x != point2.x
            {
                if point1.x > point2.x
                {
                    arr.append(walkAction(time: TimeInterval(point1.x - point2.x)*3/400,
                                          moveTo: CGPoint.init(x: point2.x, y: point1.y),
                                          direction: 3,
                                          unit: unit))
                }
                else
                {
                    arr.append(walkAction(time: TimeInterval(point2.x - point1.x)*3/400,
                                          moveTo: CGPoint.init(x: point2.x, y: point1.y),
                                          direction: 4,
                                          unit: unit))
                }
            }
            if point1.y != point2.y
            {
                if point1.y > point2.y
                {
                    arr.append(walkAction(time: TimeInterval(point1.y - point2.y)*3/400,
                                          moveTo: CGPoint.init(x: point2.x, y: point2.y),
                                          direction: 1,
                                          unit: unit))
                }
                else
                {
                    arr.append(walkAction(time: TimeInterval(point2.y - point1.y)*3/400,
                                          moveTo: CGPoint.init(x: point2.x, y: point2.y),
                                          direction: 2,
                                          unit: unit))
                }
            }
        }
        let action = SKAction.run {
            unit.data?.isWalk = false
            unit.hp?.size = CGSize.init(width: (unit.data?.hp)!/2, height: 10)
            if unit.tag == 0
            {
                unit.node?.texture = self.capWaitArray[2]
                unit.node?.xScale = 1
                self.addTimer()
            }
            else
            {
                unit.node?.texture = self.npcWaitArray[2]
                unit.node?.xScale = -1
            }
        }
        arr.append(action)
        return arr
    }
    func walkTextureArr(dir: Int) -> Array<SKTexture>
    {
        switch dir {
        case 1:
            return npcWalkDownArray
        case 2:
            return npcWalkUpArray
        case 3:
            return npcWalkLeftArray
        case 4:
            return npcWalkLeftArray
        case 11:
            return capWalkDownArray
        case 12:
            return capWalkUpArray
        default:
            return capWalkLeftArray
        }
    }
}

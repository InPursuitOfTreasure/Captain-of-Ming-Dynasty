//
//  HnsPreFightHandle.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/5/15.
//  Copyright © 2017年 hns. All rights reserved.
//

import Foundation
import SpriteKit

class HnsPreFightHandle
{
    let addTexture = SKTexture.init(imageNamed: "buttonAdd")
    let addSize = CGSize.init(width: 30, height: 30)
    
    func initAddNode(name: String, isFlip: Bool, positionX: Int, positionY: Int) -> SKSpriteNode
    {
        let node = SKSpriteNode.init(texture: addTexture, size: addSize)
        if isFlip
        {
            node.xScale = -1
        }
        node.name = name
        node.zPosition = 100
        node.position = CGPoint.init(x: positionX, y: positionY)
        node.color = SKColor.darkGray
        return node
    }
    
    func setDataOfFightScene(scene1: HnsFightScene, scene2: HnsPreFightScene)
    {
        var unit = HnsFightUnit()
        unit.data = setCaptionUnitData(data: scene2)
        scene1.captionUnit = unit
        
        var texture = SKTexture.init(imageNamed: "capHead")
        var head = HnsFightHead()
        head.head = HnsFightNode.init(texture: texture, size: CGSize.init(width: 30, height: 30))
        scene1.captionHead = head
        
        var array1: Array<HnsFightUnit> = []
        var array2: Array<HnsFightHead> = []
        
        texture = SKTexture.init(imageNamed: "npcHead")
        let count = npcCount()
        for i in 0...count-1
        {
            unit = HnsFightUnit()
            unit.data = setNpcUnitData()
            unit.tag = i + 1
            array1.append(unit)
            
            head = HnsFightHead()
            head.tag = i + 1
            head.head = HnsFightNode.init(texture: texture, size: CGSize.init(width: 30, height: 30))
            head.head?.tag = i + 1
            head.head?.name = "unitOrHead"
            head.head?.color = .darkGray
            array2.append(head)
        }
        scene1.npcUnitArr = array1
        scene1.npcHeadArr = array2
    }
    func setCaptionUnitData(data: HnsPreFightScene) -> HnsFightUnitData
    {
        let unitData = HnsFightUnitData()
        unitData.hp = 1
        unitData.speed += Int(data.pointArr[0].text!)!
        unitData.attack += Int(data.pointArr[1].text!)!
        unitData.defence += Int(data.pointArr[2].text!)!
        let position = data.buttonNormal.position
        if position.x == 125
        {
            unitData.isArmour = true
        }
        else
        {
            unitData.isArmed = true
        }
        return unitData
    }
    func setNpcUnitData() -> HnsFightUnitData
    {
        let unitData = HnsFightUnitData()
        unitData.hp = 100
        unitData.speed = Int(arc4random() % 5) + 1
        unitData.attack = Int(arc4random() % 5) + 1
        unitData.defence = Int(arc4random() % 5) + 1
        return unitData
    }
    func npcCount() -> Int
    {
        var count = 0
        for i in 0...HnsInnerScene.innerScene.npcArray.count-1
        {
            let npc = HnsInnerScene.innerScene.npcArray[i]
            if npc.will < 20
            {
                count += 1
            }
        }
        return count
    }
}

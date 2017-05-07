//
//  HnsRiver.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/3/27.
//  Copyright © 2017年 hns. All rights reserved.
//

import SpriteKit
import Foundation

class HnsRiver
{
//    var contactFlag: Bool = false
//    var contactDirection: Int = 0

    func initWithSize(width: Int, height: Int) -> SKSpriteNode
    {
        let node = SKSpriteNode.init()
        node.size = CGSize.init(width: width, height: height)
        node.physicsBody = SKPhysicsBody.init(rectangleOf: node.size, center: CGPoint.init(x: 0.5, y: 0.5))
        node.physicsBody?.categoryBitMask = HnsBitMaskType.river
        node.physicsBody?.contactTestBitMask = HnsBitMaskType.me
        node.physicsBody?.isDynamic = false
        node.physicsBody?.usesPreciseCollisionDetection = true
//        node.color = .red
        return node
    }
}
class HnsHouse
{
    //    var contactFlag: Bool = false
    //    var contactDirection: Int = 0
    
    func initWithSize(width: Int, height: Int, type: String, zPosition: Int, tag: Int) -> HnsHouseNode
    {
        let name = "house_" + type
        let node = HnsHouseNode.init(texture: SKTexture.init(imageNamed: name), size: CGSize.init(width: width, height: height))
        node.tag = tag
        
        node.zPosition = CGFloat(zPosition)
        node.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize.init(width: width - 40, height: height - 60), center: CGPoint.init(x: 0.5, y: 0.4))
        node.physicsBody?.categoryBitMask = HnsBitMaskType.house
        node.physicsBody?.contactTestBitMask = HnsBitMaskType.me
        node.physicsBody?.isDynamic = false
        node.physicsBody?.usesPreciseCollisionDetection = true
        return node
    }
}

class HnsHouseNode: SKSpriteNode
{
    var tag: Int = 0
}

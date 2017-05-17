//
//  HnsFightUnit.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/5/15.
//  Copyright © 2017年 hns. All rights reserved.
//

import Foundation
import SpriteKit

class HnsFightUnitData
{
    var hp: Int = 100
    var speed: Int = 1
    var attack: Int = 5
    var defence: Int = 5
    var direction: Int = 0
    var isWait: Bool = false
    var isWalk: Bool = false
    var isAttack: Bool = false
    var isDefence: Bool = false
    var isArmed: Bool = false
    var isArmour: Bool = false
}

class HnsFightUnit
{
    var tag: Int = 0
    var data: HnsFightUnitData? = nil
    var node: HnsFightNode? = nil
    var chooseFrame: SKSpriteNode? = nil
    var hp: SKSpriteNode? = nil
}

class HnsFightNode: SKSpriteNode
{
    var tag: Int = 0
}

class HnsFightHead
{
    var tag: Int = 0
    var head: HnsFightNode? = nil
}

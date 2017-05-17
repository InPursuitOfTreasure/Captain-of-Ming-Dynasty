//
//  HnsBitMaskType.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/3/14.
//  Copyright © 2017年 hns. All rights reserved.
//

import Foundation

class HnsBitMaskType
{
    class var me: UInt32 {
        return 1 << 0
    }
    
    class var house: UInt32 {
        return 1 << 1
    }
    
    class var river: UInt32 {
        return 1 << 2
    }
    class var npc: UInt32 {
        return 1 << 3
    }
    class var cap: UInt32 {
        return 1 << 4
    }
}

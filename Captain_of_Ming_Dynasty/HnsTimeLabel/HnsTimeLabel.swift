//
//  HnsTimeLabel.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/3/2.
//  Copyright © 2017年 hns. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation

class HnsTimeLabel
{
//    after swift3, dispatch_once_t is unavailable
//    use lazily initialized globals or static properties
//    Since they’ve already banned it, I’d better give it up.
    static var timeDic: Dictionary<String, Int> = ["year"   : 0,
                                                   "month"  : 0,
                                                   "day"    : 0,
                                                   "hour"   : 0]
    var hnsHandle: HnsTimeHandle = HnsTimeHandle()
    static let timeLabel = SKSpriteNode.init(texture: SKTexture(imageNamed: "timeBackground"), size: CGSize(width: 270, height: 44))
    static let timeText = SKLabelNode.init(fontNamed:"STKaiti")

    func initTimeLabel(width: Int) //-> SKSpriteNode
    {
        if HnsTimeLabel.timeDic["year"] == 0
        {
            HnsTimeLabel.timeDic = hnsHandle.getTimeDic()
            
            HnsTimeLabel.timeText.text = hnsHandle.calendar(time: HnsTimeLabel.timeDic)
            HnsTimeLabel.timeText.fontColor = SKColor.black
            HnsTimeLabel.timeText.fontSize  = 24
            HnsTimeLabel.timeText.position  = CGPoint(x: width - 135, y: 12)
            HnsTimeLabel.timeText.zPosition = 100
            //timeText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
            
            HnsTimeLabel.timeLabel.position = CGPoint(x: width - 135, y: 22)
            //HnsTimeLabel.timeLabel.addChild(HnsTimeLabel.timeText)
        }
    }
    
    func updateTimeLabel()
    {
        HnsTimeLabel.timeText.text = hnsHandle.calendar(time: HnsTimeLabel.timeDic)
    }
    
}

//
//  HnsMapHandle.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/1/5.
//  Copyright © 2017年 hns. All rights reserved.
//

import Foundation
import SpriteKit

class HnsMapHandle
{
    //in accordance with touch.location, return the direction, 1 means left, 2 means right, 3 means up, 4 means down, 0 means don't move
    func calculateDirection(location: CGPoint) -> Int
    {
        var x: CGFloat = location.x
        var y: CGFloat = location.y
        x -= 368
        y -= 207
        //touch center of screen, stop moving.
        if (abs(x) < 50)&&(abs(y) < 50)
        {
            return 0
        }
        if (x / y > 1)||(x / y < -1)
        {
            if x > 0
            {
                return 1    //left
            }
            else
            {
                return -1   //right
            }
        }
        else
        {
            if y > 0
            {
                return 3    //up
            }
            else
            {
                return -3   //down
            }
        }
    }
    
    func save(position: Array<CGFloat>, time: Dictionary<String, Int>)
    {
        let filePath: NSString = NSHomeDirectory().appending("/Documents/save.plist") as NSString
        
        let dic = NSDictionary(contentsOfFile: filePath as String)
        
        dic?.setValue(position, forKey: "position")
        dic?.setValue(time,     forKey: "time")
        dic?.write(toFile: filePath as String, atomically:true)
    }
    
    func updateTimeDic()
    {
        var dic = HnsTimeLabel.timeDic
        var year = dic["year"]! - 1628
        var month = dic["month"]!
        var day = dic["day"]!
        var hour = dic["hour"]!
        
        hour += 1
        if hour > 12
        {
            hour = 1
            day += 1
            if day > 30
            {
                day = 1
                month += 1
                if month > 12
                {
                    month = 1
                    year += 1
                }
            }
        }
        HnsTimeLabel.timeDic["year"]    = year + 1628
        HnsTimeLabel.timeDic["month"]   = month
        HnsTimeLabel.timeDic["day"]     = day
        HnsTimeLabel.timeDic["hour"]    = hour
    }
    
    func drawPath() -> CGPath
    {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -1830, y: -1250))
        path.addLine(to: CGPoint(x: -1830, y: -1230))
        path.addLine(to: CGPoint(x: -228, y: -1230))
        path.addLine(to: CGPoint(x: -228, y: -70))
        path.addLine(to: CGPoint(x: -2196, y: -70))
        return path
    }
    
    func updateRiver(riverArray: Array<SKSpriteNode>)
    {
        let x = HnsMapScene.hnsMapScene.mapNode.position.x
        let y = HnsMapScene.hnsMapScene.mapNode.position.y
        
        var river: SKSpriteNode
        river = riverArray[0]
        river.position = CGPoint.init(x: 2400 + x, y: 1314 + y)
        
        river = riverArray[1]
        river.position = CGPoint.init(x: 1658 + x, y: 1314 + y)
        
        river = riverArray[2]
        river.position = CGPoint.init(x: 987 + x, y: 1314 + y)
        
        river = riverArray[3]
        river.position = CGPoint.init(x: 784 + x, y: 1189 + y)
        
        river = riverArray[4]
        river.position = CGPoint.init(x: 784 + x, y: 739 + y)
        
        river = riverArray[5]
        river.position = CGPoint.init(x: 987 + x, y: 600 + y)
        
        river = riverArray[6]
        river.position = CGPoint.init(x: 1658 + x, y: 600 + y)
        
        river = riverArray[7]
        river.position = CGPoint.init(x: 2400 + x, y: 600 + y)
    }
    func updateHouse(houseArray: Array<SKSpriteNode>)
    {
        let x = HnsMapScene.hnsMapScene.mapNode.position.x
        let y = HnsMapScene.hnsMapScene.mapNode.position.y
        
        var house: SKSpriteNode
        house = houseArray[0]
        house.position = CGPoint.init(x: 480 + x, y: 1040 + y)
        
        house = houseArray[1]
        house.position = CGPoint.init(x: 2500 + x, y: 1500 + y)
        
        house = houseArray[2]
        house.position = CGPoint.init(x: 1020 + x, y: 1150 + y)
        
        house = houseArray[3]
        house.position = CGPoint.init(x: 1020 + x, y: 800 + y)
        
        house = houseArray[4]
        house.position = CGPoint.init(x: 1800 + x, y: 1150 + y)
        
        house = houseArray[5]
        house.position = CGPoint.init(x: 1800 + x, y: 800 + y)
        
        house = houseArray[6]
        house.position = CGPoint.init(x: 2244 + x, y: 1150 + y)
        
        house = houseArray[7]
        house.position = CGPoint.init(x: 2244 + x, y: 800 + y)
    }
}


//
//  HnsFightHandle.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/5/15.
//  Copyright © 2017年 hns. All rights reserved.
//

import Foundation
import SpriteKit

class HnsFightHandle
{
    func getTextureArray(type: String, strArray: Array<String>) -> Array<SKTexture>
    {
        let allTexture = SKTexture.init(imageNamed: type)
        
        let filePath = Bundle.main.path(forResource: type, ofType: "plist")!
        let dic = NSDictionary(contentsOfFile: filePath)
        
        var arr: Array<SKTexture> = []
        
        for str in strArray
        {
            let frameStr = dic?.object(forKey: str) as! String
            let charset = CharacterSet(charactersIn:"{,} ")
            let array = frameStr.components(separatedBy: charset)
            let yNum = 297 - Double(array[4])! as Double
            
            let rect = CGRect.init(x: (Double(array[2])! / 295),
                                   y: yNum / 354,
                                   width: (Double(array[8])! / 295),
                                   height: (Double(array[10])! / 354))
            arr.append(SKTexture.init(rect: rect, in: allTexture))
        }
        return arr
    }
    
    func createUnit(unit: HnsFightUnit, position: CGPoint)
    {
        unit.node = HnsFightNode.init(color: .black, size: CGSize.init(width: 50, height: 50))
        unit.node?.tag = unit.tag
        unit.node?.name = "unitOrHead"
        unit.node?.position = position
        
        unit.chooseFrame = SKSpriteNode.init(texture: SKTexture.init(imageNamed: "choose_bg"), size: CGSize.init(width: 60, height: 60))
        unit.chooseFrame?.position = position
        unit.chooseFrame?.isHidden = true
        unit.hp = SKSpriteNode.init(color: .red, size: CGSize.init(width: 50, height: 10))
        unit.hp?.anchorPoint = CGPoint.init(x: 0, y: 0)
        unit.hp?.position = CGPoint(x: position.x-25, y: position.y + 30)
        unit.hp?.zPosition = 100
    }
}

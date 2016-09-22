//
//  MapScene.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 16/9/13.
//  Copyright © 2016年 hns. All rights reserved.
//

import SpriteKit
class MapScene : SKScene {
    let spriteNode = SKSpriteNode(imageNamed:"map.jpg")
    override func didMoveToView(view: SKView) {
        
        spriteNode.size = CGSizeMake(self.size.width*4, self.size.height*4)
        spriteNode.anchorPoint = CGPointZero
        //spriteNode.position = CGPointMake(0, 0)
        let filepath: NSString = NSBundle.mainBundle().pathForResource("save", ofType: "plist")!
        var dic = NSDictionary(contentsOfFile: filepath as String)! as Dictionary
        let arr = dic["position"]?.array
//        var arr = value?.array
        
        let x = arr![0] as! CGFloat
        let y = arr![1] as! CGFloat
        
        spriteNode.position = CGPointMake(x, y)
        
        self.addChild(spriteNode)
    }
    override func update(currentTime: NSTimeInterval) {
//        var x: CGFloat = spriteNode.position.x
//        var y: CGFloat = spriteNode.position.y
//        x -= 16
//        y -= 9
//        spriteNode.position = CGPointMake(x, y)
    }
}

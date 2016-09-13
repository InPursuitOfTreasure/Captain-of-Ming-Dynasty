//
//  MapScene.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 16/9/13.
//  Copyright © 2016年 hns. All rights reserved.
//

import SpriteKit
class MapScene : SKScene {
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor(red: 1, green: 0.9, blue: 0.7, alpha: 1)
        
        let spriteNode = SKSpriteNode(imageNamed:"Background")
        
        spriteNode.position = CGPoint(x:CGRectGetMidX(self.frame)+50, y:CGRectGetMidY(self.frame))
        spriteNode.size = CGSizeMake(self.size.width-300, self.size.height)
        
        self.addChild(spriteNode)
    }
}

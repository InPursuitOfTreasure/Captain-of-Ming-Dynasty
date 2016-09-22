//
//  GameScene.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 16/9/13.
//  Copyright (c) 2016年 hns. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        
        //self.backgroundColor = SKColor(red: 1, green: 0.9, blue: 0.7, alpha: 1)
        let backNode = SKSpriteNode(imageNamed: "background.jpg")
        backNode.anchorPoint = CGPointZero
        backNode.position = CGPointMake(0, 0)
        self.addChild(backNode)
        
        let myLabel1 = SKLabelNode(fontNamed:"STKaiti")
        myLabel1.text = "大明百夫长"
        myLabel1.fontColor = SKColor.blackColor()
        myLabel1.fontSize = 45
        myLabel1.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel1)
        
        let myLabel2 = SKLabelNode(fontNamed:"Chalkduster")
        myLabel2.text = "Captain of Ming Dynasty"
        myLabel2.fontColor = SKColor.blackColor()
        myLabel2.fontSize = 45
        myLabel2.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+60)
        
        self.addChild(myLabel2)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //after touch, turn to the next scene
        let mapScene = MapScene(size: self.size)
        
        let doors = SKTransition.fadeWithDuration(0.7)
        
        self.view?.presentScene(mapScene, transition: doors)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

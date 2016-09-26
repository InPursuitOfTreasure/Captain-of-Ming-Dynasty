//
//  MapScene.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 16/9/13.
//  Copyright © 2016年 hns. All rights reserved.
//

import SpriteKit
class MapScene : SKScene {
    
    //in swift, a variable need a default value. Or there is a worning: Class has no initializers. Use ? to solve it
    //func update need a defaulf value, so give a (368, 207)
    var touchLocation: CGPoint = CGPoint(x: 368, y: 207)
    //地图
    var spriteNode = SKSpriteNode(imageNamed: "map.jpg")
    //人物
    var meNode = SKSpriteNode(texture: SKTexture(imageNamed: "captain1"))
    
    override func didMove(to view: SKView) {
        createSpriteNode()
        createMeNode()
    }
    override func update(_ currentTime: TimeInterval) {
        var x: CGFloat = spriteNode.position.x
        var y: CGFloat = spriteNode.position.y
        switch direction() {
        case 1:
            x -= 16
            meNode.texture = SKTexture(imageNamed: "captain1")
        case 2:
            x += 16
            meNode.texture = SKTexture(imageNamed: "captain2")
        case 3:
            y -= 9
            meNode.texture = SKTexture(imageNamed: "captain3")
        case 4:
            meNode.texture = SKTexture(imageNamed: "captain4")
            y += 9
        default: break
        }
        spriteNode.position = CGPoint(x: x, y: y)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let hnsTouches = touches as NSSet
        let touch = hnsTouches.anyObject() as! UITouch
        touchLocation = touch.location(in: self)
    }
    //
    func direction() -> Int {
        var x: CGFloat = touchLocation.x
        var y: CGFloat = touchLocation.y
        x -= 368
        y -= 207
        //touch center of screen, stop moving.
        if (abs(x) < 30)&&(abs(y) < 30) {
            return 0
        }
        if (x / y > 1)||(x / y < -1) {
            if x > 0 {
                return 1    //left
            } else {
                return 2    //right
            }
        } else {
            if y > 0 {
                return 3    //up
            } else {
                return 4    //down
            }
        }
    }
    //one-time function
    func createSpriteNode() {
        spriteNode.size = CGSize(width: self.size.width*4, height: self.size.height*4)
        spriteNode.anchorPoint = CGPoint.zero
        
        let filepath: NSString = Bundle.main.path(forResource: "save", ofType: "plist")! as NSString
        let dic = NSDictionary(contentsOfFile: filepath as String)
        let arr = dic!.object(forKey: "position") as! NSArray
        
        let x = arr[0] as! CGFloat
        let y = arr[1] as! CGFloat
        
        spriteNode.position = CGPoint(x: x, y: y)
        
        self.addChild(spriteNode)
    }
    func createMeNode() {
        meNode.size = CGSize(width: 100, height: 100)
        
        meNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        self.addChild(meNode)
    }
}

//
//  MapScene.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 16/9/13.
//  Copyright © 2016年 hns. All rights reserved.
//

import SpriteKit

class MapScene : SKScene {
    
    //the note, never run
    func annotation() {
        //SKUtil.m: MGGetBoolAnswer is not available in the simulator.
        //the concole will fill up with these messages.
        //https://forums.developer.apple.com/thread/62983
        //the apple staff member said:"This is a harmless message. It will be removed in the next release. Sorry for the confusion."
        
        //in swift, a variable need a default value. Or there is a worning: Class has no initializers. Use ? to solve it
        
        //the map is 4 multiplier, so, the biggest point is (-368*8, -207*8)
    }
    
    //func update need a defaulf value, so give value (368, 207), it is center
    var touchLocation: CGPoint = CGPoint(x: 368, y: 207)
    
    //map
    var mapNode = SKSpriteNode(imageNamed: "map.jpg")
    
    //captain
    //long long after, maybe use textureSets to do the gif
    var meNode = SKSpriteNode(texture: SKTexture(imageNamed: "captain1"))
    
    //direction
    //when game begans, captain don't move, so give value 0
    //when scene change and go back, also need value 0, this quesition is not solved until now, recorded on 2016.12.25, marry Charismas.
    var direction: Int = 0
    
    //map, captain, exit
    override func didMove(to view: SKView) {
        createMapNode()
        createMeNode()
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(MapScene.longPress))
        self.view?.addGestureRecognizer(longpress)
    }
    
    override func update(_ currentTime: TimeInterval) {
        var x: CGFloat = mapNode.position.x
        var y: CGFloat = mapNode.position.y
        switch direction {
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
            y += 9
            meNode.texture = SKTexture(imageNamed: "captain4")
        default: break
        }
        mapNode.position = CGPoint(x: x, y: y)
    }
    
    //when touchs calculate the direction, to move.
    //judge if there is a npc, or if there needs a click event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let hnsTouches = touches as NSSet
        let touch = hnsTouches.anyObject() as! UITouch
        touchLocation = touch.location(in: self)
        direction = calculateDirection()
    }
    
    //in accordance with touch.location, return the direction, 1 means left, 2 means right, 3 means up, 4 means down, 0 means don't move
    func calculateDirection() -> Int {
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
    
    //create the map
    func createMapNode() {
        mapNode.size = CGSize(width: self.size.width*4, height: self.size.height*4)
        mapNode.anchorPoint = CGPoint.zero
        
        //let filePath: NSString = Bundle.main.path(forResource: "save", ofType: "plist")! as NSString
        let filePath: NSString = NSHomeDirectory().appending("/Documents/save.plist") as NSString
        print(filePath)
        let dic = NSDictionary(contentsOfFile: filePath as String)
        let arr = dic!.object(forKey: "position") as! NSArray
        
        let timeDic = dic!.object(forKey: "time") as! NSDictionary
        let str = calendar(time: timeDic)
        print(str)
        
        let x = arr[0] as! CGFloat
        let y = arr[1] as! CGFloat
        
        mapNode.position = CGPoint(x: x, y: y)
        
        self.addChild(mapNode)
    }
    
    //create captain, he stay at center forever
    func createMeNode() {
        meNode.size = CGSize(width: 100, height: 100)
        meNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(meNode)
    }
    
    //long press to save and exit
    func longPress() {
        var x: CGFloat = touchLocation.x
        var y: CGFloat = touchLocation.y
        x -= 368
        y -= 207
        //long press center of screen, save and exit.
        if (abs(x) < 30)&&(abs(y) < 30) {
            let filePath: NSString = NSHomeDirectory().appending("/Documents/save.plist") as NSString
            print(filePath)
            let dic = NSDictionary(contentsOfFile: filePath as String)
            
            let x = mapNode.position.x
            let y = mapNode.position.y
            let arr = [x, y]
            
            dic?.setValue(arr, forKey: "position")
            dic?.write(toFile: filePath as String, atomically:true)
            
            exit(0)
        }
    }
    
}

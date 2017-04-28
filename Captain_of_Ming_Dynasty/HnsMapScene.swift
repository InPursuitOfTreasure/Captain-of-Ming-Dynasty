//
//  HnsMapScene.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 16/9/13.
//  Copyright © 2016年 hns. All rights reserved.
//

import SpriteKit

var texture1 = SKTexture.init(imageNamed: "captain1")
var texture2 = SKTexture.init(imageNamed: "captain2")
var texture3 = SKTexture.init(imageNamed: "captain3")
var texture4 = SKTexture.init(imageNamed: "captain4")

class HnsMapScene : SKScene, SKPhysicsContactDelegate
{
    //the note, never run
    func annotation()
    {
        //SKUtil.m: MGGetBoolAnswer is not available in the simulator.
        //the concole will fill up with these messages.
        //https://forums.developer.apple.com/thread/62983
        //the apple staff member said:"This is a harmless message. It will be removed in the next release. Sorry for the confusion."
        
        //in swift, a variable need a default value. Or there is a worning: Class has no initializers. Use ? to solve it
        
        //the map is 4 multiplier, so, the biggest point is (-368*8, -207*8)
    }
    
    static var hnsMapScene = HnsMapScene.init()
    
    //func update need a defaulf value, so give value (368, 207), it is center
    var touchLocation: CGPoint = CGPoint(x: 368, y: 207)
    
    //map
    var mapNode = SKSpriteNode.init(imageNamed: "map.jpg")
    
    //captain
    //long long after, maybe use textureSets to do the gif
    
    var meNode = SKSpriteNode.init(texture: texture1)
    
    var riverNode: Array<SKSpriteNode> = [
                    HnsRiver().initWithSize(width: 616, height: 80),
                    HnsRiver().initWithSize(width: 600, height: 80),
                    HnsRiver().initWithSize(width: 470, height: 80),
                    HnsRiver().initWithSize(width:  84, height: 272),
                    HnsRiver().initWithSize(width:  84, height: 333),
                    HnsRiver().initWithSize(width: 470, height: 70),
                    HnsRiver().initWithSize(width: 600, height: 70),
                    HnsRiver().initWithSize(width: 616, height: 70),
                    ]
    var houseNode: Array<SKSpriteNode> = [
        HnsHouse().initWithSize(width: 320, height: 210, type: "1", zPosition: -1),
        HnsHouse().initWithSize(width: 320, height: 210, type: "4", zPosition: -1),
        HnsHouse().initWithSize(width: 320, height: 210, type: "2", zPosition: -1),
        HnsHouse().initWithSize(width: 320, height: 210, type: "8", zPosition: 200),
        HnsHouse().initWithSize(width: 270, height: 210, type: "1", zPosition: -1),
        HnsHouse().initWithSize(width: 270, height: 210, type: "1", zPosition: 200),
        HnsHouse().initWithSize(width: 270, height: 210, type: "1", zPosition: -1),
        HnsHouse().initWithSize(width: 270, height: 210, type: "1", zPosition: 200),
        ]
    //direction
    //when game begans, captain don't move, so give value 0
    //when scene change and go back, also need value 0, this quesition is not solved until now, recorded on 2016.12.25, marry Charismas.
    var direction: Int = 0
    var oldDirection: Int = 0
    var backDirection: Int = 0
    
    //handle, many functions to process the data
    var hnsHandle: HnsMapHandle = HnsMapHandle()
    
    //timer to handle timeDic
    var timer: Timer?
    
    //map, captain, exit
    override func didMove(to view: SKView)
    {
        self.createMapNode()
        self.createMeNode()
        self.createTimeLabel()
        
        //let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        //self.view?.addGestureRecognizer(longpress)
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        updateMapNode(direction: self.direction)
        hnsHandle.updateRiver(riverArray: self.riverNode)
        hnsHandle.updateHouse(houseArray: self.houseNode)
    }
    
    //when touchs calculate the direction, to move.
    //judge if there is a npc, or if there needs a click event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let hnsTouches = touches as NSSet
        let touch = hnsTouches.anyObject() as! UITouch
        touchLocation = touch.location(in: self)
        direction = hnsHandle.calculateDirection(location: touchLocation)
    }
    
    //create the map
    func createMapNode()
    {
        DispatchQueue(label: "com.hns.mapQueue").async
        {
            self.mapNode.anchorPoint = CGPoint.zero
            self.mapNode.size = CGSize(width: self.size.width*4, height: self.size.height*4)
            
            //let filePath: NSString = Bundle.main.path(forResource: "save", ofType: "plist")! as NSString
            let filePath: NSString = NSHomeDirectory().appending("/Documents/save.plist") as NSString
            print(filePath)
            let dic = NSDictionary(contentsOfFile: filePath as String)
            let arr = dic!.object(forKey: "position") as! NSArray
            
            let x = arr[0] as! CGFloat
            let y = arr[1] as! CGFloat
            
            self.mapNode.position = CGPoint(x: x, y: y)
            self.mapNode.zPosition = -100
            self.hnsHandle.updateRiver(riverArray: self.riverNode)
            self.hnsHandle.updateHouse(houseArray: self.houseNode)
            
            DispatchQueue.main.async
            {
                self.physicsWorld.contactDelegate = self
                self.physicsWorld.gravity = CGVector.init(dx: 0, dy: 0)
                for i in 0 ... self.riverNode.count-1
                {
                    self.addChild(self.riverNode[i])
                }
                for i in 0 ... self.houseNode.count-1
                {
                    self.addChild(self.houseNode[i])
                }
                self.addChild(self.mapNode)
            }
        }
    }
    
    //create captain, he stay at center forever
    func createMeNode()
    {
        DispatchQueue(label: "com.hns.meQueue").async
        {
            self.meNode.size = CGSize(width: 100, height: 100)
            self.meNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            self.meNode.physicsBody = SKPhysicsBody.init(rectangleOf: self.meNode.frame.size)
            self.meNode.physicsBody?.categoryBitMask = HnsBitMaskType.me
            self.meNode.physicsBody?.contactTestBitMask = HnsBitMaskType.house
            self.meNode.physicsBody?.allowsRotation = false
            self.meNode.physicsBody?.affectedByGravity = false
            self.mapNode.zPosition = 150
            
            DispatchQueue.main.async
            {
                self.addChild(self.meNode)
            }
        }
    }
    
    //creat the time label
    func createTimeLabel()
    {
        DispatchQueue(label: "com.hns.timeLabelQueue").async
        {
            HnsTimeLabel().initTimeLabel(width: Int(self.frame.width))
            HnsTimeLabel.timeLabel.zPosition = 1000
            HnsTimeLabel.timeText .zPosition = 1001
            
            DispatchQueue.main.async
            {
                self.addTimer()
                self.addChild(HnsTimeLabel.timeLabel)
                self.addChild(HnsTimeLabel.timeText)
            }
        }
    }
    
    //long press to save and exit
//    func longPress()
//    {
//        var x: CGFloat = touchLocation.x
//        var y: CGFloat = touchLocation.y
//        x -= 368
//        y -= 207
//        //long press center of screen, save and exit.
//        if (abs(x) < 30)&&(abs(y) < 30)
//        {
//            let x = mapNode.position.x
//            let y = mapNode.position.y
//            let arr = [x, y]
//            
//            removeTimer()
//            hnsHandle.saveAndExit(position: arr, time: HnsTimeLabel.timeDic)
//        }
//    }
    
    func addTimer()
    {
        if (timer == nil)
        {
            timer = Timer.init(timeInterval: 2, target: self, selector: #selector(handleTimeDic), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        }
    }
    
    @objc func handleTimeDic()
    {
        hnsHandle.updateTimeDic()
        HnsTimeLabel().updateTimeLabel()
    }
    
    func removeTimer()
    {
        timer?.invalidate()
        timer = nil
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if  contact.bodyA.categoryBitMask == HnsBitMaskType.river
            ||
            contact.bodyB.categoryBitMask == HnsBitMaskType.river
        {
            backDirection = -direction
            direction = 0
            oldDirection = 0
        }
        if  contact.bodyA.categoryBitMask == HnsBitMaskType.house
            ||
            contact.bodyB.categoryBitMask == HnsBitMaskType.house
        {
            backDirection = -direction
            direction = 0
            oldDirection = 0
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact)
    {
        backDirection = 0
        direction = 0
        oldDirection = 0
        self.meNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
    }
    
    func updateMapNode(direction: Int)
    {
        if backDirection != 0
        {
            if direction != backDirection && direction != 0
            {
                return
            }
        }
        var x: CGFloat = mapNode.position.x
        var y: CGFloat = mapNode.position.y
        switch direction
        {
        case 1:
            if x > -2192
            {
                x -= 16
            }
            if (oldDirection != direction)
            {
                oldDirection = direction
                meNode.texture = texture1
            }
        case -1:
            if x < -256
            {
                x += 16
            }
            if (oldDirection != direction)
            {
                oldDirection = direction
                meNode.texture = texture2
            }
        case 3:
            if y > -1212
            {
                y -= 9
            }
            if (oldDirection != direction)
            {
                oldDirection = direction
                meNode.texture = texture3
            }
        case -3:
            if y < -81
            {
                y += 9
            }
            if (oldDirection != direction)
            {
                oldDirection = direction
                meNode.texture = texture4
            }
        default:
            if backDirection != 0
            {
                self.direction = backDirection
                oldDirection = backDirection
            }
        }
        mapNode.position = CGPoint(x: x, y: y)
    }
}

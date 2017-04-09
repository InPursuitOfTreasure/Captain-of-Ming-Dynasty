//
//  HnsMapHandle.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/1/5.
//  Copyright © 2017年 hns. All rights reserved.
//

import Foundation
import SpriteKit

//in accordance with touch.location, return the direction, 1 means left, 2 means right, 3 means up, 4 means down, 0 means don't move
func calculateDirection(location: CGPoint) -> Int {
    var x: CGFloat = location.x
    var y: CGFloat = location.y
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

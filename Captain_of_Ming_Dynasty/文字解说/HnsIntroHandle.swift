//
//  HnsIntroHandle.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/5/5.
//  Copyright © 2017年 hns. All rights reserved.
//

import Foundation

func setTextArrayByTag(tag: Int) -> Array<String>
{
    let filePath: String = Bundle.main.path(forResource: "intro", ofType: "plist")!
    let dic = NSDictionary(contentsOfFile: filePath)
    var arr: Array<String>? = nil
    
    switch tag {
    case 0:
        arr = dic!.object(forKey: "start") as! Array<String>?
    case 1:
        arr = dic!.object(forKey: "farmer1") as! Array<String>?
    case 2:
        arr = dic!.object(forKey: "farmer2") as! Array<String>?
    case 3:
        arr = dic!.object(forKey: "farmer3") as! Array<String>?
    case 4:
        arr = dic!.object(forKey: "farmer4") as! Array<String>?
    case 5:
        arr = dic!.object(forKey: "shopkeeper") as! Array<String>?
    case 6:
        arr = dic!.object(forKey: "carpenter") as! Array<String>?
    case 7:
        arr = dic!.object(forKey: "ironsmith") as! Array<String>?
    case 8:
        arr = dic!.object(forKey: "end0") as! Array<String>?
    case 9:
        arr = dic!.object(forKey: "end1") as! Array<String>?
    case 10:
        arr = dic!.object(forKey: "end2") as! Array<String>?
    case 11:
        arr = dic!.object(forKey: "end3") as! Array<String>?
    case 12:
        arr = dic!.object(forKey: "end4") as! Array<String>?
    case 13:
        arr = dic!.object(forKey: "end5") as! Array<String>?
    case 14:
        arr = dic!.object(forKey: "end6") as! Array<String>?
    case 15:
        arr = dic!.object(forKey: "end7") as! Array<String>?
    default:
        arr = HnsIntroScene.introScene.textArray
    }
    return arr!
}

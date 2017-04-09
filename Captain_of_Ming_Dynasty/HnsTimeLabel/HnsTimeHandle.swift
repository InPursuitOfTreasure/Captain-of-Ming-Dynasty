//
//  HnsTimeLang.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/3/2.
//  Copyright © 2017年 hns. All rights reserved.
//

import Foundation

func calendar(time: NSDictionary) -> String {
    let year = time.object(forKey: "year") as! Int - 1628
    let month = time.object(forKey: "month") as! Int
    let day = time.object(forKey: "day") as! Int
    //let hour = time.object(forKey: "hour") as! Int
    
    var str = ""
    switch year {
    case 0: str = "崇祯元年"
    case 1: str = "崇祯一年"
    case 2: str = "崇祯二年"
    case 3: str = "崇祯三年"
    case 4: str = "崇祯四年"
    case 5: str = "崇祯五年"
    case 6: str = "崇祯六年"
    case 7: str = "崇祯七年"
    case 8: str = "崇祯八年"
    case 9: str = "崇祯九年"
    case 10: str = "崇祯十年"
    case 11: str = "崇祯十一年"
    case 12: str = "崇祯十二年"
    case 13: str = "崇祯十三年"
    case 14: str = "崇祯十四年"
    case 15: str = "崇祯十五年"
    case 16: str = "崇祯十六年"
    case 17: str = "崇祯十七年"
    default:
        str = "未知年代"
    }
    if month > 0 && month < 13 {
        str += String.localizedStringWithFormat("%d月", month)
    }
    if day > 0 && day < 31 {
        str += String.localizedStringWithFormat("%d日", day)
    }
    
    return str
}

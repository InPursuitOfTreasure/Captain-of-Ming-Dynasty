//
//  HnsTimeHandle.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/3/2.
//  Copyright © 2017年 hns. All rights reserved.
//

import Foundation

class HnsTimeHandle
{
    func calendar(time: Dictionary<String, Int>) -> String
    {
        let year = time["year"]! - 1628
        let month = time["month"]!
        let day = time["day"]!
        let hour = time["hour"]!
        
        var str = ""
        switch year
        {
        case 0  : str = "崇祯元年"
        case 1  : str = "崇祯一年"
        case 2  : str = "崇祯二年"
        case 3  : str = "崇祯三年"
        case 4  : str = "崇祯四年"
        case 5  : str = "崇祯五年"
        case 6  : str = "崇祯六年"
        case 7  : str = "崇祯七年"
        case 8  : str = "崇祯八年"
        case 9  : str = "崇祯九年"
        case 10 : str = "崇祯十年"
        case 11 : str = "崇祯十一年"
        case 12 : str = "崇祯十二年"
        case 13 : str = "崇祯十三年"
        case 14 : str = "崇祯十四年"
        case 15 : str = "崇祯十五年"
        case 16 : str = "崇祯十六年"
        case 17 : str = "崇祯十七年"
        default : str = "未知年代  "
        }
        if month > 0 && month < 13
        {
            str += String.localizedStringWithFormat("%d月", month)
        }
        if day > 0 && day < 31
        {
            str += String.localizedStringWithFormat("%d日", day)
        }
        switch hour
        {
        case 1  : str += "子时"
        case 2  : str += "丑时"
        case 3  : str += "寅时"
        case 4  : str += "卯时"
        case 5  : str += "辰时"
        case 6  : str += "巳时"
        case 7  : str += "午时"
        case 8  : str += "未时"
        case 9  : str += "申时"
        case 10 : str += "酉时"
        case 11 : str += "戌时"
        case 12 : str += "亥时"
        default : str += "？？"
        }
        
        return str
    }
    func getTimeDic() -> Dictionary<String, Int>
    {
        let filePath: String = NSHomeDirectory() + "/Documents/save.plist"
        var dic = NSDictionary(contentsOfFile: filePath)
        if dic == nil
        {
            HnsMapHandle().reset()
            dic = NSDictionary(contentsOfFile: filePath)
        }
        return dic!.object(forKey: "time") as! Dictionary<String, Int>
    }
    func getTimeDicAsNumber() -> Int
    {
        let timeDic = getTimeDic()
        var time:Int = timeDic["year"]! * 10000
        time += timeDic["month"]! * 100
        time += timeDic["day"]!
        return time
    }
}

//
//  HnsTask.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/5/7.
//  Copyright © 2017年 hns. All rights reserved.
//

import Foundation

class HnsTask
{
    static let task = HnsTask()
    static var goodDic: Dictionary<String, Int> = ["iron"   : 0,
                                                "silver"  : 0,
                                                "wood"    : 0,
                                                "food"   : 0]
    var tid: Int = 0
    var time: Int = 0
    var intro: String = ""
    //影响
    var type: Int = 0
    var affect: Int = 0
    var taskType: Int = 0
    var days: Int = 0
    var progress: Int = 0
    
    func affectPeople(type: Int) -> String
    {
        if HnsTask.task.progress == 0
        {
            return "暂无"
        }
        var t = type
        var flag = false
        var str: String = ""
        let arr = HnsInnerScene.innerScene.npcArray
        let aff = HnsTask.task.affect
        let att = HnsTask.task.taskType
        if t > 7 {
            arr[6].dailyTask = att
            arr[6].will += aff
            t -= 8
            str = "铁匠"
            flag = true
        }
        if t > 3 {
            arr[5].dailyTask = att
            arr[5].will += aff
            t -= 4
            if flag
            {
                str += "、木匠"
            }
            else
            {
                flag = true
                str = "木匠"
            }
        }
        if t > 1 {
            arr[4].dailyTask = att
            arr[4].will += aff
            t -= 2
            if flag
            {
                str += "、掌柜"
            }
            else
            {
                flag = true
                str = "掌柜"
            }
        }
        if t > 0 {
            arr[3].dailyTask = att
            arr[2].dailyTask = att
            arr[1].dailyTask = att
            arr[0].dailyTask = att
            arr[3].will += aff
            arr[2].will += aff
            arr[1].will += aff
            arr[0].will += aff
            if flag
            {
                str += "、农夫"
            }
            else
            {
                str = "农夫"
            }
        }
        return str
    }
    
    func loadGoodDic()
    {
        let filePath: String = NSHomeDirectory() + "/Documents/save.plist"
        var dic = NSDictionary(contentsOfFile: filePath)
        if dic == nil
        {
            HnsMapHandle().reset()
            dic = NSDictionary(contentsOfFile: filePath)
        }
        let good = dic!.object(forKey: "good") as! Dictionary<String, Int>
        HnsTask.goodDic["iron"] = good["iron"]
        HnsTask.goodDic["silver"] = good["silver"]
        HnsTask.goodDic["wood"] = good["wood"]
        HnsTask.goodDic["food"] = good["food"]
    }
    
    func loadTask()
    {
        let filePath: String = NSHomeDirectory() + "/Documents/save.plist"
        print(filePath)
        var dic = NSDictionary(contentsOfFile: filePath)
        if dic == nil
        {
            HnsMapHandle().reset()
            dic = NSDictionary(contentsOfFile: filePath)
        }
        let taskDic = dic!.object(forKey: "task") as! NSDictionary
        
        var tid = taskDic["tid"] as! Int
        HnsTask.task.progress = taskDic["progress"] as! Int
        if HnsTask.task.progress == 0
        {
            tid += 1
        }
        HnsSqlite3.sqlHandle.loadtask(tid: tid, task: HnsTask.task)
    }
    
    func taskType(taskType: Int) -> String
    {
        switch taskType
        {
        case 1:
            return "帮忙砍柴"
        case 2:
            return "温和交谈"
        case 3:
            return "慷慨解囊"
        case 4:
            return "帮忙挖矿"
        case 5:
            return "周济米粮"
        default:
            return ""
        }
    }
}

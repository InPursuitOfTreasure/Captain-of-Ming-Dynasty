//
//  HnsSqlite3.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 17/5/7.
//  Copyright © 2017年 hns. All rights reserved.
//

import Foundation

class HnsSqlite3
{
    static let sqlHandle = HnsSqlite3.init()
    var db1 : OpaquePointer? = nil
    var db2 : OpaquePointer? = nil
    var stmt : OpaquePointer? = nil
    
    func closeDB()
    {
        sqlite3_close(db1)
        sqlite3_close(db2)
    }
    
    func deleteData()
    {
        let sql = "delete from npc"
        execSQL(SQL: sql)
        resetData()
    }
    
    func execSQL(SQL : String)
    {
        let cSQL = SQL.cString(using: .utf8)
        if sqlite3_exec(db1, cSQL, nil, nil, nil) != SQLITE_OK
        {
            print("sql语句执行失败")
        }
    }
    
    func loadData(tag: Int, npc: HnsNpc)
    {
        let searchCount = ("select * from npc where pid = " + String(tag)).cString(using: .utf8)
        if sqlite3_prepare_v2(db1, searchCount, -1, &stmt, nil) == SQLITE_OK
        {
            if sqlite3_step(stmt) == SQLITE_ROW
            {
                //pid,type,typeName,name,will,wealth,dailyTask
                let cType = sqlite3_column_int(stmt, 2)
                let cName = sqlite3_column_text(stmt, 3)
                let cWill = sqlite3_column_int(stmt, 4)
                let cWealth = sqlite3_column_int(stmt, 5)
                let cDailyTask = sqlite3_column_int(stmt, 6)
                
                npc.type = Int(cType)
                npc.name = String(describing: cName)
                npc.will = Int(cWill)
                npc.wealth = Int(cWealth)
                npc.dailyTask = Int(cDailyTask)
            }
        }
        sqlite3_finalize(stmt)
    }
    
    func loadtask(tid: Int, task: HnsTask)
    {
        let searchCount = ("select * from taskDef where tid = " + String(tid)).cString(using: .utf8)
        print(sqlite3_prepare_v2(db2, searchCount, -1, &stmt, nil))
        if sqlite3_prepare_v2(db2, searchCount, -1, &stmt, nil) == SQLITE_OK
        {
            if sqlite3_step(stmt) == SQLITE_ROW
            {
                let time = sqlite3_column_int(stmt, 1)
                let intro = UnsafePointer(sqlite3_column_text(stmt, 2))
                let type = sqlite3_column_int(stmt, 4)
                let affect = sqlite3_column_int(stmt, 5)
                let taskType = sqlite3_column_int(stmt, 7)
                let days = sqlite3_column_int(stmt, 8)
                
                task.time = Int(time)
                task.intro = String.init(cString: intro!)
                task.type = Int(type)
                task.affect = Int(affect)
                task.taskType = Int(taskType)
                task.days = Int(days)
            }
        }
        sqlite3_finalize(stmt)
    }
    
    func openDB()
    {
        let DBPath = NSHomeDirectory() + "/Documents/dataDB.sqlite"
        let cDBPath = DBPath.cString(using: .utf8)
        
        if sqlite3_open(cDBPath, &db1) != SQLITE_OK {
            print("数据库打开失败")
        }
        //if not exists, create table, init the npc's data
        resetData()
        
        let path = Bundle.main.path(forResource: "Ming_Dynasty_Data", ofType: "sqlite")?.cString(using: .utf8)
        if sqlite3_open(path, &db2) != SQLITE_OK {
            print("数据库打开失败")
        }
    }
    
    func resetData()
    {
        let creatNpcTable = "CREATE TABLE IF NOT EXISTS 'npc' (pid integer NOT NULL UNIQUE,type integer NOT NULL,typeName text NOT NULL,name text NOT NULL UNIQUE,will integer NOT NULL, wealth integer NOT NULL,dailyTask integer  NOT NULL);"
        execSQL(SQL: creatNpcTable)
        
        let searchCount = "select pid from npc where pid = 1".cString(using: .utf8)
        if sqlite3_prepare_v2(db1, searchCount, -1, &stmt, nil) == SQLITE_OK
        {
            if sqlite3_step(stmt) != SQLITE_ROW
            {
                let insert1 = "INSERT INTO 'npc' VALUES ("
                let insert2 = ");"
                let insert =  insert1 + "1,1,'农夫','李自成',80,0,0" + insert2
                            + insert1 + "2,1,'农夫','高迎祥',80,0,0" + insert2
                            + insert1 + "3,1,'农夫','马守应',80,0,0" + insert2
                            + insert1 + "4,1,'农夫','贺一龙',80,0,0" + insert2
                            + insert1 + "5,2,'掌柜','罗汝才',80,0,0" + insert2
                            + insert1 + "6,4,'木匠','张献忠',80,0,0" + insert2
                            + insert1 + "7,8,'铁匠','王二',80,0,0" + insert2
                execSQL(SQL: insert)
            }
        }
    }
    
    func updateData(tag: Int, npc: HnsNpc)
    {
        let sql1 = "update npc set will = " + String(npc.will) + " where pid = " + String(tag)
        let sql3 = "update npc set wealth = " + String(npc.wealth) + " where pid = " + String(tag)
        let sql2 = "update npc set dailyTask = " + String(npc.dailyTask) + " where pid = " + String(tag)
        execSQL(SQL: sql1)
        execSQL(SQL: sql2)
        execSQL(SQL: sql3)
    }
}

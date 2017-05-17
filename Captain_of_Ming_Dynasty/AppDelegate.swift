//
//  AppDelegate.swift
//  Captain_of_Ming_Dynasty
//
//  Created by 黄纽舒 on 16/9/13.
//  Copyright © 2016年 hns. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        print(Bundle.main.bundlePath)
        HnsMapScene.mapScene.size = (window?.frame.size)!
        HnsMapScene.mapScene.createMapNode()
        HnsMapScene.mapScene.createMeNode()
        HnsMapScene.mapScene.createTimeLabel()
        HnsMapScene.mapScene.createAlert()
        
        HnsIntroScene.introScene.size = (window?.frame.size)!
        HnsIntroScene.introScene.create_background_textNode()
        
        HnsSqlite3.sqlHandle.openDB()
        HnsTask.task.loadTask()
        HnsTask().loadGoodDic()
        HnsTimeHandle().getTimeDic()
        
        HnsInnerScene.innerScene.size = (window?.frame.size)!
        HnsInnerScene.innerScene.create_background_npcNode()
        HnsInnerScene.innerScene.createBedNode()
        HnsInnerScene.innerScene.createMeNode()
        HnsInnerScene.innerScene.createTalk()
        HnsInnerScene.innerScene.reloadNpc()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        HnsMapScene.mapScene.hnsHandle.save()
        HnsMapScene.mapScene.removeTimer()
        
        HnsInnerScene.innerScene.saveToDB()
        HnsSqlite3.sqlHandle.closeDB()
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        HnsMapScene.mapScene.addTimer()
        HnsSqlite3.sqlHandle.openDB()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        HnsMapScene.mapScene.hnsHandle.save()
        HnsMapScene.mapScene.removeTimer()
        
        HnsInnerScene.innerScene.saveToDB()
        HnsSqlite3.sqlHandle.closeDB()
    }
}


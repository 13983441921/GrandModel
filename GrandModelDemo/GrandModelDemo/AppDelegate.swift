//
//  AppDelegate.swift
//  GrandModelDemo
//
//  Created by Tyrant on 2/27/16.
//  Copyright © 2016 Qfq. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //在这里测试就行了
        let a = DemoModel()
        a.name = "123"
        a.gender = Gender.Female
        a.id = 111
        print(a)
        let data = NSKeyedArchiver.archivedDataWithRootObject(a)
        let s = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        print(s)
        
        
        let b = DemoModel1()
        b.bookId = 1212
        b.bookName = "我是一个白痴"
        b.bookClass = "文学"
        print(b)
        let data1 = NSKeyedArchiver.archivedDataWithRootObject(b)
        let t = NSKeyedUnarchiver.unarchiveObjectWithData(data1)
        print(t)
        
        //测试好像没什么问题
        //下面来写一个映射
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

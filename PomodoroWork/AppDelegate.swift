//
//  AppDelegate.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/4/8.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
//        ADLaunchPage()// 广告
        registerNotifications()
        configureTabBarColor()
        IQkeyBoard()// 弹出键盘设置 
        
        return true
    }
    
    func IQkeyBoard() {
        let keyboardManager = IQKeyboardManager.sharedManager()
        keyboardManager.shouldResignOnTouchOutside = true
        keyboardManager.toolbarManageBehaviour = .bySubviews
    }
    
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//        print("didReceiveLocalNotification")
        timerViewController.presentAlertFromNotification(notification)
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//         print("结束App-A")
        let recodeVC = RecordTableViewController()
        recodeVC.saveTodayData()
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        resetBadgeNumber()
    }

    func applicationWillTerminate(_ application: UIApplication) {
//        print("applicationWillTerminate")
        timerViewController.pause()
    }
    
    
    // MARK: -- 帮助文件
    
    fileprivate var timerViewController: TimerViewController {
        let tabBarController = window!.rootViewController as! UITabBarController
        return tabBarController.viewControllers!.first as! TimerViewController
    }
    
    fileprivate func registerNotifications() {
        //通知设置：提醒 标记 声音
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                                              categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
    }
    //
    fileprivate func resetBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    fileprivate func configureTabBarColor() {
        UITabBar.appearance().tintColor = UIColor(
            red: 240/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1)
    }
    
    fileprivate func ADLaunchPage() {
        let adImageGifPath:String = Bundle.main.path(forResource: "ADP1", ofType: "png")!
        
        HHLaunchAdPageHUD.init(frame: CGRect.init(x: 0, y: 0, width: HHScreenWidth, height: HHScreenHeight), aDduration: 4, aDImageUrl: adImageGifPath, hideSkipButton: false) {
//            print("[AppDelegate]:点了广告图片")
            UIApplication.shared.openURL(URL.init(string: "http://www.bmw.com.cn/zh/all-models/m-series/m4-coupe/2017/m4-cs.html")!)
          }
    }
    
    
    


}


//
//  SettingsManager.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/4/9.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import Foundation

// Singleton object to retrieve and retain app settings
// 单例对象  取回 和 保留 app 的设定值

// 设置管理器
class SettingsManager {
    
    static let sharedManager = SettingsManager()
    fileprivate init() {}
    
    fileprivate let userDefaults = UserDefaults.standard
    fileprivate let notificationCenter = NotificationCenter.default
    
    fileprivate struct Settings {
        static let pomodoroLength = "Settings.PomodoroLength"
        static let shortBreakLength = "Settings.ShortBreakLength"
        static let longBreakLength = "Settings.LongBreakLength"
        static let targetPomodoros = "Settings.TargetPomodoros"
    }
    
    // MARK: - General settings
    
    var pomodoroLength: Int {
        // 时钟时长不设置，默认为 5min
        get { return userDefaults.object(forKey: Settings.pomodoroLength) as? Int ?? 60 * 60 }
        set { userDefaults.set(newValue, forKey: Settings.pomodoroLength) }
    }
    // 短休息 默认为 5 min
    var shortBreakLength: Int {
        get { return userDefaults.object(forKey: Settings.shortBreakLength) as? Int ?? 5 * 60 }
        set { userDefaults.set(newValue, forKey: Settings.shortBreakLength) }
    }
    // 长休息 默认为 20 min
    var longBreakLength: Int {
        get { return userDefaults.object(forKey: Settings.longBreakLength) as? Int ?? 20 * 60 }
        set { userDefaults.set(newValue, forKey: Settings.longBreakLength) }
    }
    // 目标任务书数 默认为 16 个
    var targetPomodoros: Int {
        get { return userDefaults.object(forKey: Settings.targetPomodoros) as? Int ?? 16 }
        set {
            userDefaults.set(newValue, forKey: Settings.targetPomodoros)
            notificationCenter.post(name: Notification.Name(rawValue: "targetPomodorosUpdated"), object: self)
        }
    }
    
}


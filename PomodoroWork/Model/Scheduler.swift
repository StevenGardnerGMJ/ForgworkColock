//
//  Scheduler.swift
//  PomodoroWork
//
//  Created by gemaojing on 2018/4/9.
//  Copyright © 2018年 葛茂菁. All rights reserved.
//

import UIKit

protocol SchedulerDelegate: class {
    func schedulerDidPause()
    func schedulerDidUnpause()
    func schedulerDidStart()
    func schedulerDidStop()
}

// 时刻表
class Scheduler {
    
    weak var delegate: SchedulerDelegate?
    
    fileprivate let userDefaults = UserDefaults.standard
    fileprivate let settings = SettingsManager.sharedManager
    fileprivate let pomodoro = Pomodoro.sharedInstance
    
    // Interval for rescheduling timers 重新安排计时器的时间间隔
    var pausedTime: Double? {
        get {
            return userDefaults.object(forKey: "PausedTime") as? Double
        }
        set {
            if let value = newValue, value != 0 {
                userDefaults.set(value, forKey: "PausedTime")
            } else {
                userDefaults.removeObject(forKey: "PausedTime")
            }
        }
    }
    
    // Date representing fire date of scheduled notification
    
    /// 通知日期变更
    var fireDate: Date? {
        get {
            return userDefaults.object(forKey: "FireDate") as? Date
        }
        set {
            if let value = newValue {
                userDefaults.set(value, forKey: "FireDate")
            } else {
                userDefaults.removeObject(forKey: "FireDate")
            }
        }
    }
    
    // Returns paused if paused time present
    var paused: Bool {
        return pausedTime != nil
    }
    
    func start() {
        switch pomodoro.state {
        case .default: schedulePomodoro()
        case .shortBreak: scheduleShortBreak()
        case .longBreak: scheduleLongBreak()
        }
        
        delegate?.schedulerDidStart()
//        print("Scheduler started")
    }
    
    func pause(_ interval: TimeInterval) {
        pausedTime = interval
        cancelNotification()
        
        delegate?.schedulerDidPause()
//        print("Scheduler paused")
    }
    
    func unpause() {
        guard let interval = pausedTime else { return }
        
        switch pomodoro.state {
        case .default: schedulePomodoro(interval)
        case .shortBreak: scheduleShortBreak(interval)
        case .longBreak: scheduleLongBreak(interval)
        }
        
        pausedTime = nil
        
        delegate?.schedulerDidUnpause()
//        print("Scheduler unpaused")
    }
    
    func stop() {
        pausedTime = nil
        cancelNotification()
        
        delegate?.schedulerDidStop()
//        print("Scheduler stopped")
    }
    
    // MARK: - Helpers
    
    fileprivate var firstScheduledNotification: UILocalNotification? {
        return UIApplication.shared.scheduledLocalNotifications?.first
    }
    
    fileprivate func cancelNotification() {
        UIApplication.shared.cancelAllLocalNotifications()
        fireDate = nil
//        print("Notification canceled")
    }
    
    fileprivate func schedulePomodoro(_ interval: TimeInterval? = nil) {
        let interval = interval ?? TimeInterval(settings.pomodoroLength)
        scheduleNotification(interval,
                             title: "陛下是时候休息一下!", body: "此阶段任务完成，建议工作时间在90min内 避免过度疲劳")
//        print("Pomodoro scheduled")
    }
    
    fileprivate func scheduleShortBreak(_ interval: TimeInterval? = nil) {
        let interval = interval ?? TimeInterval(settings.shortBreakLength)
        scheduleNotification(interval,
                             title: "陛下该回去努力了!", body: "短暂休息完成")
//        print("Short break scheduled")
    }
    
    fileprivate func scheduleLongBreak(_ interval: TimeInterval? = nil) {
        let interval = interval ?? TimeInterval(settings.longBreakLength)
        scheduleNotification(interval,
                             title: "陛下是时候回去继续努力了!", body: "长时休息完成")
//        print("Long break scheduled")
    }
    
    fileprivate func scheduleNotification(_ interval: TimeInterval, title: String, body: String) {
        let notification = UILocalNotification()
        notification.fireDate = Date(timeIntervalSinceNow: interval)
        notification.alertTitle = title
        notification.alertBody = body
        notification.applicationIconBadgeNumber = 1
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
        
        fireDate = notification.fireDate
        
//        print("Pomodoro notification scheduled for \(notification.fireDate!)")
    }
    
}

